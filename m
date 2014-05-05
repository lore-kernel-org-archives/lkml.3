Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaEET0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:26:39 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:64021 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaEET0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:26:37 -0400
Date: Mon, 5 May 2014 15:26:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com, olebowle@gmx.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/base: add managed token devres interfaces
Message-ID: <20140505192633.GQ11231@htj.dyndns.org>
References: <cover.1398797954.git.shuah.kh@samsung.com>
 <6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
 <20140501145337.GC31611@htj.dyndns.org>
 <5367E39E.7090401@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5367E39E.7090401@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shuah.

On Mon, May 05, 2014 at 01:16:46PM -0600, Shuah Khan wrote:
> You are right that there is a need for an owner field to indicate who
> has the token. Since the path is very long, I didn't want to use just
> the mutex and keep it tied up for long periods of time. That is the
> reason why I added in_use field that marks it in-use or free. I hold
> the mutex just to change the token status. This is what you are seeing
> on the the following path:

Can you tell me the difference between the following two?

my_trylock1() {
	if (!mutex_trylock(my_lock->lock))
		return -EBUSY;
	was_busy = my_lock->busy;
	my_lock->busy = true;
	mutex_unlock(my_lock->lock);
	return was_busy ? -EBUSY : 0;
}

my_trylock2() {
	mutex_lock();
	was_busy = my_lock->busy;
	my_lock->busy = true;
	mutex_unlock(my_lock->lock);
	return was_busy ? -EBUSY : 0;
}

Now, because the only operation you support is trylock and unlock,
neither will malfunction (as contention on the inner lock can only
happen iff there's another lock holder).  That said, the code doesn't
make any sense.

Here's the problem.  I really don't feel comfortable acking the
submitted code which implements a locking primitive when the primary
author who would probably be the primary caretaker of the code for the
time being doesn't really seem to understand basics of
synchronization.

I'm sure that this could just be from lack of experience but at least
for now I really think this should at least be gated through someone
else who's more knowledgeable and I defintely don't think I'm setting
the bar too high here.

As such, please consider the patches nacked and try to find someone
who can shepherd the code.  Mauro, can you help out here?

Thanks.

-- 
tejun
