Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaCKPY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:24:26 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:22450 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaCKPYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:24:25 -0400
Message-ID: <1394551460.11149.6.camel@j-VirtualBox>
Subject: Re: [tip:core/locking] locking/mutexes: Modify the way optimistic
 spinners are queued
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Tue, 11 Mar 2014 08:24:20 -0700
In-Reply-To: <tip-47667fa1502e4d759df87e9cc7fbc0f202483361@git.kernel.org>
References: <1390936396-3962-3-git-send-email-jason.low2@hp.com>
	 <tip-47667fa1502e4d759df87e9cc7fbc0f202483361@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 05:41 -0700, tip-bot for Jason Low wrote:

> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index e6d646b..82dad2c 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -403,9 +403,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	if (!mutex_can_spin_on_owner(lock))
>  		goto slowpath;
>  
> +	mcs_spin_lock(&lock->mcs_lock, &node);
>  	for (;;) {
>  		struct task_struct *owner;
> -		struct mcs_spinlock  node;

Hi Peter, Ingo,

The "struct mcs_spinlock node" still needs to be moved to the beginning
of __mutex_lock_common() right?

