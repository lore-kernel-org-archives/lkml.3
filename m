Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaBKBd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:33:28 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26455 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaBKBd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:33:27 -0500
Message-ID: <1392082398.2918.33.camel@j-VirtualBox>
Subject: Re: [PATCH 3/8] mutex: Modify the way optimistic spinners are queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Mon, 10 Feb 2014 17:33:18 -0800
In-Reply-To: <20140210203659.532019477@infradead.org>
References: <20140210195820.834693028@infradead.org>
	 <20140210203659.532019477@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 20:58 +0100, Peter Zijlstra wrote:
> Cc: tglx@linutronix.de
> Cc: riel@redhat.com
> Cc: akpm@linux-foundation.org
> Cc: davidlohr@hp.com
> Cc: hpa@zytor.com
> Cc: andi@firstfloor.org
> Cc: aswin@hp.com
> Cc: mingo@kernel.org
> Cc: scott.norton@hp.com
> Cc: chegu_vinod@hp.com
> Cc: Waiman.Long@hp.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: torvalds@linux-foundation.org
> Signed-off-by: Jason Low <jason.low2@hp.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1390936396-3962-3-git-send-email-jason.low2@hp.com
> ---
>  kernel/locking/mutex.c |   17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -403,9 +403,9 @@ __mutex_lock_common(struct mutex *lock,
>  	if (!mutex_can_spin_on_owner(lock))
>  		goto slowpath;
>  
> +	mcs_spin_lock(&lock->mcs_lock);

Where did the mcs node go? :)

