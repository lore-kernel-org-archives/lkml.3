Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3I0FpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:45:09 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59022 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3I0FpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:45:06 -0400
Message-ID: <52451B5D.4080908@colorfullife.com>
Date: Fri, 27 Sep 2013 07:45:01 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ipc,shm: prevent race with rmid in shmat(2)
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com> <1379300677-24188-3-git-send-email-davidlohr@hp.com>
In-Reply-To: <1379300677-24188-3-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

On 09/16/2013 05:04 AM, Davidlohr Bueso wrote:
> This fixes a race in shmat() between finding the msq and
> actually attaching the segment, as another thread can delete shmid
> underneath us if we are preempted before acquiring the kern_ipc_perm.lock.
According the the man page, Linux supports attaching to deleted shm 
segments:

http://linux.die.net/man/2/shmat
>
> On Linux, it is possible to attach a shared memory segment even if it 
> is already marked to be deleted. However, POSIX.1-2001 does not 
> specify this behavior and many other implementations do not support it.
>
Does your patch change that?
Unfortunately, I have neither any experience with ipc/shm nor any test 
cases.

And:
As far as I can see it's not a problem if we are attaching to a deleted 
segment: shm_close cleans up everything.

--
     Manfred
