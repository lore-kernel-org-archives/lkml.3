Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3E0P5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:57:16 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56073 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3E0P5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:57:15 -0400
Message-ID: <51A38257.2020804@colorfullife.com>
Date: Mon, 27 May 2013 17:57:11 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] ipc/sem.c: Bug fixes, regression fixes, v3
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <1369601453.2259.15.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1369601453.2259.15.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On 05/26/2013 10:50 PM, Davidlohr Bueso wrote:
>
> In lack of getting my swingbench DSS environment back, I ran these
> changes against the semop-multi program on my laptop. For 256 threads,
> with Manfred's patchset the ops/sec suffers around -7.3%.

Could you also check the performance of only patch#1?
I fear that it might be slower than all 4 together.

With regards to semop-multi:
Is this the tool?
http://marc.info/?l=linux-kernel&m=136208613626892&q=p3

I think the logic is the wrong:
Locking a semaphore is substraction, unlocking adding.
Thus multiple tasks can run in parallel - and the task switch code is 
never triggered.
Could you double check that the number of context switches matches the 
output?

I usually use this tool:
http://marc.info/?l=linux-kernel&m=125038376609750


--
     Manfred
