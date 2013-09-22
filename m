Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3IVMod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 08:44:33 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43838 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3IVMoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 08:44:32 -0400
Message-ID: <523EE627.40408@gmail.com>
Date: Sun, 22 Sep 2013 20:44:23 +0800
From: Jia He <jiakernel@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com>	 <1379837823.5499.34.camel@marge.simpson.net>	 <1379838364.5499.39.camel@marge.simpson.net> <523EB997.9090107@gmail.com> <1379844021.5598.8.camel@marge.simpson.net>
In-Reply-To: <1379844021.5598.8.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

On Sun, 22 Sep 2013 12:00:21 +0200 from bitbucket@online.de wrote:
> On Sun, 2013-09-22 at 17:34 +0800, Jia He wrote: 
>> Thanks for the comments, but pls add my email as "from jiakernel@gmail.com"
>> if you have a better implementation.U know, it is my first kernel patch, maybe
>> will give me a brilliant memory in the future :)
> You can have the blame if you like :)
>
>> Anyway, your implementation looks not correct to me. Because from "man semop"
>> sem_otime will record the last sem operation time of semop. If you change the
>> otime in semget(), it changes the meanings in stardard, doesn't it?
> A Linux kernel doing a semop in 1970 would be a kinda neat trick :)
I will try to make it more clear
comes to my test case again:

process_a(server)       process_b(client)
semget()                                  <-seems you choose to set it here
---------------  <1>  --------------------
semctl(SETVAL)
semop()
                        semget()
                        setctl(IP_STAT)
                        for(;;) {
                          check until sem_otime > 0
                        }
And assume that schedule() happenes at <1>, then sem_otime will >0
in process_b's for(;;), but at that time, the process_a's semctl() 
hasn't been called yet.

>
> -Mike
>
> .
>

