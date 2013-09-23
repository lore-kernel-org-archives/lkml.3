Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IWCYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:24:45 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39707 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3IWCYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:24:43 -0400
Message-ID: <523FA664.2070101@gmail.com>
Date: Mon, 23 Sep 2013 10:24:36 +0800
From: Jia He <jiakernel@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>,
        Manfred Spraul <manfred@colorfullife.com>
CC: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com>	 <1379837823.5499.34.camel@marge.simpson.net>	 <1379838364.5499.39.camel@marge.simpson.net>	 <523EC97D.8020707@colorfullife.com> <1379898516.5476.27.camel@marge.simpson.net>
In-Reply-To: <1379898516.5476.27.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

On Mon, 23 Sep 2013 03:08:36 +0200 from bitbucket@online.de wrote:
> On Sun, 2013-09-22 at 12:42 +0200, Manfred Spraul wrote:
>
>> Mike: no, your patch makes it worse:
>> - wait-for-zero semops still don't update sem_otime
>> - sem_otime is initialized to sem_ctime. That's not mentioned in the 
>> sysv standard.
> So sem_otime = 0 is a specified semaphore state?  I thought the proggy
> was busted for spinning on a (busted and) irrelevant stamp.
Please refer to the words from Unix Network Programming - Volume 2 2nd
Edition Chapter 11
"Fortunately, there is a way around this race condition. We are guaranteed
that thesem-otime member of the semid-ds structure is set to 0 when a
new semaphore set iscreated. (The System V manuals have stated this
fact for a long time, as do the XPG3and Unix 98 standards.) This member
is set to the current time only by a successful callto semop."
>
> Man lernt nie aus.
>
> -Mike
>
>

