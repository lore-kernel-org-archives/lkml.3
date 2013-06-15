Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3FOIga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 04:36:30 -0400
Received: from mout.gmx.net ([212.227.17.20]:57921 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab3FOIg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 04:36:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5C+JhvLf5aywKCgrBEG9UDvND1oar6JIku7KbIF
	qaBmssYgXOZrVr
Message-ID: <1371285380.5789.42.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Jun 2013 10:36:20 +0200
In-Reply-To: <1371281407.5789.24.camel@marge.simpson.net>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
	 <1371236750.5796.54.camel@marge.simpson.net>
	 <51BBFB34.20206@colorfullife.com>
	 <1371275319.5789.13.camel@marge.simpson.net>
	 <1371281407.5789.24.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 09:30 +0200, Mike Galbraith wrote:

> Gee, just trying to flip back to a single semaphore lock mode if you had
> to do the global wait thing fixed up -rt.

But master wants a sharper rock tossed at it, it's still unstable.

Result matrix:
  Thread   0: 11190947
  Thread   1: 11743861
  Thread   2: 10039223
  Thread   3:  9776111
  Thread   4:  9734815
  Thread   5:  9941121
  Thread   6: 11604118
  Thread   7: 11716281
  Thread   8:  9828587
  Thread   9:  9589199
...

And that's one of the better samples.  Probably -rt sleepy locks help
get us flipped back to single sem lock mode.

Hohum.  On the bright side, -rt gets to scale better than mainline for a
little while, that's kinda different.

-Mike

