Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaCYQBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:01:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaCYQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:01:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Xen <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH] Xen: do hv callback accounting only on x86
Date: Tue, 25 Mar 2014 17:00:21 +0100
Message-ID: <12121341.4lKFpaRMcO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5057041.71iuvlcH4G@wuerfel>
References: <5057041.71iuvlcH4G@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4NNkgRlyhQmbl/i9l6stTqiqacy5OWjmZgPYTKQEZqy
 Rwjcof3xY3IbmTAH5vvh8pPvrwb5L3Fv3NpBhPOsJMwhC9fpdM
 5PJm9FzVxQOzgCggG6XSa7QNebjZII0JYjQ41VmDx3dfLSO4Yu
 R1z3U7xvcxrBlnx8UhfRlytRHmu2aDifCGB2WFjgnrJILkzH7I
 UbPDaQ1OOEwg3B/Fo0Gtq8jFhnJWZ4SXczmiR6IMCFJX0ol8Ul
 Gpr8wELqYNIaSyYBhPYEAcvJytlzdLTuMMJIa1Mhs8bJn0OdzW
 Q8qSdgsD4MJhlQC1vq5HyXcffWvHcTBvq0mfRhbYaSLkpGYSz5
 80wWKpbvblPYOvO1DacY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2014 16:52:25 Arnd Bergmann wrote:
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index 5dd2ddf..8b91c256 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -1235,6 +1235,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>  #ifdef CONFIG_X86
>         exit_idle();
>  #endif
> +       inc_irq_stat(irq_hv_callback_count);
> 
>         __xen_evtchn_do_upcall();
> 
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index d5a3de8..dfa12a4 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -1248,8 +1248,8 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>         irq_enter();
>  #ifdef CONFIG_X86
>         exit_idle();
> -#endif
>         inc_irq_stat(irq_hv_callback_count);
> +#endif
>  
>         __xen_evtchn_do_upcall();

That was unintended: the first half of this email is actually the patch
that introduced the bug, while the second half is my workaround.
The way it's formatted, you won't be able to apply it without removing
the first half again. I'll wait if the approach is ok first and then
resend it properly if needed.

	Arnd
