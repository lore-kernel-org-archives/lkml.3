Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJZOpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:45:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:52291 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaJZOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:45:40 -0400
Date: Sun, 26 Oct 2014 15:45:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Silverman <bsilver16384@gmail.com>
cc: austin.linux@gmail.com, linux-kernel@vger.kernel.org, darren@dvhart.com,
        peterz@infradead.org
Subject: Re: [PATCH v2] futex: fix a race condition between REQUEUE_PI and
 task death
In-Reply-To: <1414282837-23092-1-git-send-email-bsilver16384@gmail.com>
Message-ID: <alpine.DEB.2.11.1410261542080.5308@nanos>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com> <1414282837-23092-1-git-send-email-bsilver16384@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Brian Silverman wrote:
> @@ -1558,6 +1558,12 @@ retry_private:
>  		ret = get_futex_value_locked(&curval, uaddr1);
>  
>  		if (unlikely(ret)) {
> +			/*
> +			 * We will have to lookup the pi_state again, so
> +			 * free this one to keep the accounting correct.
> +			 */
> +			free_pi_state(pi_state, hb2);
> +			pi_state = NULL;

pi_state is always NULL here. No point for this call.

Thanks,

	tglx
