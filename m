Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaIXLpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:45:00 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53544 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIXLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:44:57 -0400
Message-ID: <5422AEB2.2040207@redhat.com>
Date: Wed, 24 Sep 2014 13:44:50 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 4/8] kvm, mem-hotplug: Reload L1's apic access page
 in vcpu_enter_guest().
References: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com> <1411545478-9848-5-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1411545478-9848-5-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/09/2014 09:57, Tang Chen ha scritto:
>        if (!is_guest_mode(vcpu) ||
>            !(vmx->nested.current_vmcs12->secondary_vm_exec_control &
>              SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))

Actually, this needs to use nested_cpu_has2 (in case the secondary
controls are disabled).  I fixed that for you.

Thanks!

Paolo
