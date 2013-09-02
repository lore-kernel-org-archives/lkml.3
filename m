Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab3IBHNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:13:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39764 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337Ab3IBHNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:13:07 -0400
Date: Mon, 2 Sep 2013 09:13:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        hpa@linux.intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Subject: Re: [PATCH 2/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20130902071318.GA3406@x1.alien8.de>
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
 <20130829092804.5476.95588.stgit@localhost6.localdomain6>
 <20130831052252.GC12617@x1.alien8.de>
 <5223F8DB.3040506@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5223F8DB.3040506@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 11:32:59AM +0900, HATAYAMA Daisuke wrote:
> As you suggest, boot_cpu seems more understandable also to me. BTW,
> please notice that it doesn't denote that the CPU we're booting on
> currently, but that the CPU with BSP flag set.

Hmm, by "BSP flag set" you mean it is the first LAPIC entry in the MADT,
correct? At least this is the case when you set isbsp to true. Because,
there's also the BSC flag in APIC_BAR (MSR 0x1b) which denotes the
bootstrapping core on node 0.

> In general, current code uses many terms to denote the cpu that is run
> at kernel boot-up processing such as boot cpu, bsp, cpu0 and possibly
> others since in usual situation, boot cpu is always BSP and assigned
> to cpu0. But it is not the case in case of kexec. I'm using the word
> bsp purposely in the isbsp to mean the CPU with BSP flag set.
>
> So I think it's better to use bsp_cpu here to denote the CPU with BSP
> flag set.

Right.

> For the comment, how about the following one?
> 
>         /*
>          * In this case, boot cpu is AP. This can happen on
>          * kexec/kdump. Consider the case that crash happens on some
>          * AP and enters kdump 2nd kernel with the AP.
>          *
>          * Then, there's issue that if we send INIT to BSP, due to x86
>          * hardware specification, it is forced to jump at BIOS init
>          * code and system hangs or resets immediately.
>          *
>          * To avoid the issue, we disable BSP. Then, there's no longer
>          * possbility to send INIT to BSP.
>          */

Yes, much better. Especially when looking down the road and people have
forgotten what the whole fuss was about, a nice detailed comment is
priceless.

Thanks.

-- 
Regards/Gruss,
Boris.
