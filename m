Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaGCC3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:29:09 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41129 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGCC3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:29:07 -0400
MIME-Version: 1.0
In-Reply-To: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
Date: Wed, 2 Jul 2014 22:29:06 -0400
Message-ID: <CAG4AFWboxFM7g+RL+ACawOWATHnPxG0omnfgV4DZaVBu=BzDTg@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] perf ignore LBR and offcore_rsp.
From: Jidong Xiao <jidong.xiao@gmail.com>
To: kan.liang@intel.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, andi@firstfloor.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 2:14 PM,  <kan.liang@intel.com> wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> x86, perf: Protect LBR and offcore rsp against KVM lying
>
> With -cpu host, KVM reports LBR and offcore support, if the host has support.
> When the guest perf driver tries to access LBR or offcore_rsp MSR,
> it #GPs all MSR accesses,since KVM doesn't handle LBR and offcore support.
> So check the related MSRs access right once at initialization time to avoid the error access at runtime.
>
> For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y.
This is for host kernel,
> And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n.
And this is for guest kernel, right?

-Jidong
