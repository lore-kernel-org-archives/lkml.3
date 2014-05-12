Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaELSLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:11:45 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:18950 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaELSLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:11:43 -0400
Message-ID: <1399918300.2648.24.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/6] ipc/sem.c: Bugfix for semctl(,,GETZCNT)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Date: Mon, 12 May 2014 11:11:40 -0700
In-Reply-To: <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 12:03 +0200, Manfred Spraul wrote:
> GETZCNT is supposed to return the number of threads that wait until
> a semaphore value becomes 0.
> The current implementation overlooks complex operations that contain
> both wait-for-zero operation and operations that alter at least one semaphore.

Indeed. the pending_alter list does represent blocked processes on the
sem. Good catch. Btw, how on earth did you run into this? reading the
code or a real case?

> 
> The patch fixes that.
> It's intentionally copy&paste, this will be cleaned up in the next patch.

Instead I would have expected this patch to actually come after the
count_* refactoring.


> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

