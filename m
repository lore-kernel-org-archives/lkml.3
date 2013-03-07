Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3CGHEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:04:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab3CGHEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:04:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>
Subject: Re: [patch 2/7] tick: Convert broadcast cpu bitmaps to cpumask_var_t
In-Reply-To: <20130306111537.366394000@linutronix.de>
References: <20130306111351.883117670@linutronix.de> <20130306111537.366394000@linutronix.de>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Mar 2013 16:51:23 +1100
Message-ID: <874ngnycys.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/time/tick-broadcast.c |   86 +++++++++++++++++++++----------------------
>  kernel/time/tick-common.c    |    1 
>  kernel/time/tick-internal.h  |    3 +
>  3 files changed, 46 insertions(+), 44 deletions(-)
>
> Index: tip/kernel/time/tick-broadcast.c
> ===================================================================
> --- tip.orig/kernel/time/tick-broadcast.c
> +++ tip/kernel/time/tick-broadcast.c
> @@ -28,9 +28,8 @@
>   */
>  
>  static struct tick_device tick_broadcast_device;
> -/* FIXME: Use cpumask_var_t. */
> -static DECLARE_BITMAP(tick_broadcast_mask, NR_CPUS);
> -static DECLARE_BITMAP(tmpmask, NR_CPUS);
> +static cpumask_var_t tick_broadcast_mask;
> +static cpumask_var_t tmpmask;
>  static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
>  static int tick_broadcast_force;

Thanks, this is a nice cleanup.

Cheers,
Rusty.
