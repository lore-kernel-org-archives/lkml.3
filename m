Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3F1QJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:09:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:46972 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab3F1QJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:09:17 -0400
Date: Fri, 28 Jun 2013 18:09:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 5/5] x86/xen: sync the CMOS RTC as well as the Xen
 wallclock
In-Reply-To: <51CDB0A1.6080409@citrix.com>
Message-ID: <alpine.DEB.2.02.1306281805430.4013@ionos.tec.linutronix.de>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-6-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306281727240.4013@ionos.tec.linutronix.de> <51CDB0A1.6080409@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, David Vrabel wrote:
> 
> Before:
> 
> Xen wallclock set when time is stepped.
> Xen wallclock set every 11 minutes (by sync_cmos_clock()).
> Hardware RTC never set.
> 
> After:
> 
> Xen wallclock set when time is stepped.
> Xen wallclock set every 11 minutes (in pvclock gtod notifier).

Ah, you are emulating the sync_cmos_clock() behaviour for the xen
wallclock via the periodic pvclock_gtod notifier call.

> Hardware RTC set every 11 minutes (by sync_cmos_clock()).
> 
> I'll update the changelog to be more descriptive:
> 
>   Adjustments to Xen's persistent clock via update_persistent_clock()
>   don't actually persist, as the Xen wallclock is a software only clock
>   and modifications to it do not modify the underlying CMOS RTC.
> 
>   The x86_platform.set_wallclock hook can be used to keep the hardware
>   RTC synchronized (as on bare metal).  If (in dom0) we make the Xen
>   wallclock periodically synchronized by the pvclock_gtod notifier, the
>   set_wallclock hook need not update the Xen wallclock and the native
>   implementation can be used.

Yep. I'll pick that up.

Thanks,

	tglx
