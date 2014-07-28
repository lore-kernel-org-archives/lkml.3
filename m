Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaG1Qtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:49:40 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:52639 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaG1Qti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:49:38 -0400
Message-ID: <1406566175.2411.13.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 09:49:35 -0700
In-Reply-To: <1406524724-17946-3-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-3-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:
> ... as we clearly inline mcs_spin_lock() now.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  kernel/locking/mcs_spinlock.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
> index 23e89c5..4d60986 100644
> --- a/kernel/locking/mcs_spinlock.h
> +++ b/kernel/locking/mcs_spinlock.h
> @@ -56,9 +56,6 @@ do {									\
>   * If the lock has already been acquired, then this will proceed to spin
>   * on this node->locked until the previous lock holder sets the node->locked
>   * in mcs_spin_unlock().
> - *
> - * We don't inline mcs_spin_lock() so that perf can correctly account for the
> - * time spent in this lock function.
>   */
>  static inline
>  void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)

Likewise, I'm wondering if we should make this function noinline so that
"perf can correctly account for the time spent in this lock function".


