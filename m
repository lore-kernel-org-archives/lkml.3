Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaGNLzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:55:22 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63745 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbaGNLzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:55:11 -0400
Message-ID: <53C3C517.4000500@redhat.com>
Date: Mon, 14 Jul 2014 13:55:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: kan.liang@intel.com, peterz@infradead.org
CC: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
In-Reply-To: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/07/2014 12:59, kan.liang@intel.com ha scritto:
> From: Kan Liang <kan.liang@intel.com>
>
> x86, perf: Protect LBR and extra_regs against KVM lying
>
> With -cpu host, KVM reports LBR and extra_regs support, if the host has support.
> When the guest perf driver tries to access LBR or extra_regs MSR,
> it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs support.
> So check the related MSRs access right once at initialization time to avoid the error access at runtime.
>
> For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y (for host kernel).
> And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n (for guest kernel).

I'm not sure this is a useful patch.

This is #GP'ing just because of a limitation in the PMU; just compile 
the kernel with CONFIG_PARAVIRT, or split the "rdmsr is always 
rdmsr_safe" behavior out of CONFIG_PARAVIRT and into a new Kconfig symbol.

In fact there's no reason why LBR cannot be virtualized (though it does 
need support from the processor), and it may even be possible to support 
OFFCORE_RSP_X in the KVM virtual PMU.

Paolo
