Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3FOFsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 01:48:47 -0400
Received: from mout.gmx.net ([212.227.15.15]:51982 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3FOFsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 01:48:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/qxQVclqXqHbYAEEkmrCBZAkR7ATu+EAW9dJgVcp
	0gG6pb+LkFZ0iP
Message-ID: <1371275319.5789.13.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Jun 2013 07:48:39 +0200
In-Reply-To: <51BBFB34.20206@colorfullife.com>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
	 <1371236750.5796.54.camel@marge.simpson.net>
	 <51BBFB34.20206@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 07:27 +0200, Manfred Spraul wrote:

> Assume there is one op (semctl(), whatever) that acquires the global 
> lock - and a continuous stream of simple ops.
> - spin_is_locked() returns true due to the semctl().
> - then simple ops will switch to spin_lock(&sma->sem_perm.lock).
> - since the spinlock is acquired, the next operation will get true from 
> spin_is_locked().
> 
> It will stay that way around - as long as there is at least one op 
> waiting for sma->sem_perm.lock.
> With enough cpus, it will stay like this forever.

Yup, pondered that yesterday, scratching my head over how to do better.
Hints highly welcome.  Maybe if I figure out how to scratch dual lock
thingy properly for -rt, non-rt will start acting sane too, as that spot
seems to be itchy in both kernels.

-Mike

