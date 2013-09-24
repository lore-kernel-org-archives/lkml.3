Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab3IXHfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:35:00 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55978 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3IXHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:34:59 -0400
Date: Tue, 24 Sep 2013 09:34:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 2/4] Use raw cpu ops for calls that would trigger
 with checks
Message-ID: <20130924073456.GE28538@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c3d064a-ebe0610b-6951-4a74-bd33-8480e3e1e364-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001414c3d064a-ebe0610b-6951-4a74-bd33-8480e3e1e364-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> Index: linux/kernel/hrtimer.c
> ===================================================================
> --- linux.orig/kernel/hrtimer.c	2013-09-12 13:26:29.216103951 -0500
> +++ linux/kernel/hrtimer.c	2013-09-12 13:26:29.212103994 -0500
> @@ -538,7 +538,7 @@ static inline int hrtimer_is_hres_enable
>   */
>  static inline int hrtimer_hres_active(void)
>  {
> -	return __this_cpu_read(hrtimer_bases.hres_active);
> +	return raw_cpu_read(hrtimer_bases.hres_active);
>  }

If cpu_read() is used, does this check trigger?

If yes, what makes ignoring the check safe? Per change explanation is 
necessary for such annotations.

Thanks,

	Ingo
