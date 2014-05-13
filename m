Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaEMRoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:44:01 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33005 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaEMRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:43:54 -0400
Message-ID: <537259D6.6020407@colorfullife.com>
Date: Tue, 13 May 2014 19:43:50 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Subject: Re: [PATCH 2/6] ipc/sem.c: Bugfix for semctl(,,GETZCNT)
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com> <1399716199-26776-2-git-send-email-manfred@colorfullife.com> <1399716199-26776-3-git-send-email-manfred@colorfullife.com> <1399918300.2648.24.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1399918300.2648.24.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On 05/12/2014 08:11 PM, Davidlohr Bueso wrote:
> On Sat, 2014-05-10 at 12:03 +0200, Manfred Spraul wrote:
>> GETZCNT is supposed to return the number of threads that wait until
>> a semaphore value becomes 0.
>> The current implementation overlooks complex operations that contain
>> both wait-for-zero operation and operations that alter at least one semaphore.
> Indeed. the pending_alter list does represent blocked processes on the
> sem. Good catch. Btw, how on earth did you run into this? reading the
> code or a real case?
Reading the code.
Or more accurately:
Rewriting it, i.e. I first starting coding the new semncnt/semzcnt code, 
then I noticed that the current code is buggy.

>> The patch fixes that.
>> It's intentionally copy&paste, this will be cleaned up in the next patch.
> Instead I would have expected this patch to actually come after the
> count_* refactoring.
>
In this case:
First the bugfix, as simple as possible, then the new features.

--
     Manfred
