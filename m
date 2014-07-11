Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaGKOEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:04:09 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:64949 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaGKOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140711133708.519979699@linutronix.de>
References: <20140711133623.530368377@linutronix.de>
	<20140711133708.519979699@linutronix.de>
Date: Fri, 11 Jul 2014 10:04:05 -0400
Message-ID: <CAHQdGtS8xeRUNM0T-TrC_AW3iSYZHCU-1ijiRuHMSP3kOvomZQ@mail.gmail.com>
Subject: Re: [patch 38/55] fs: lockd: Use ktime_get_ns()
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 9:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Replace the ever recurring:
>         ts = ktime_get_ts();
>         ns = timespec_to_ns(&ts);
> with
>         ns = ktime_get_ns();
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Trond Myklebust <trond.myklebust@primarydata.com>
> ---
>  fs/lockd/mon.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> Index: tip/fs/lockd/mon.c
> ===================================================================
> --- tip.orig/fs/lockd/mon.c
> +++ tip/fs/lockd/mon.c
> @@ -306,11 +306,9 @@ static struct nsm_handle *nsm_lookup_pri
>  static void nsm_init_private(struct nsm_handle *nsm)
>  {
>         u64 *p = (u64 *)&nsm->sm_priv.data;
> -       struct timespec ts;
>         s64 ns;
>
> -       ktime_get_ts(&ts);
> -       ns = timespec_to_ns(&ts);
> +       ns = ktime_get_ns();
>         put_unaligned(ns, p);
>         put_unaligned((unsigned long)nsm, p + 1);
>  }
>
>

Looks fine to me.

Acked-by: Trond Myklebust <trond.myklebust@primarydata.com>


-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com
