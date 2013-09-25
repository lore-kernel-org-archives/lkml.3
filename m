Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3IYGzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 02:55:23 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:48132 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IYGzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 02:55:22 -0400
Message-ID: <524288D4.9090407@colorfullife.com>
Date: Wed, 25 Sep 2013 08:55:16 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jia He <jiakernel@gmail.com>
CC: Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com> <1379837823.5499.34.camel@marge.simpson.net> <1379838364.5499.39.camel@marge.simpson.net> <523EC97D.8020707@colorfullife.com> <523F0953.3070505@gmail.com> <5241FF8D.8000407@colorfullife.com> <52425316.8060101@gmail.com>
In-Reply-To: <52425316.8060101@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jia,

On 09/25/2013 05:05 AM, Jia He wrote:
>   Hi Manfred
> IIUC after reivewing your patch and src code, does it seem
> sem_otime lost the chance to be updated when calling
> semctl_main/semctl_setval?
> In old codes, even whendo_smart_update(sma, NULL, 0, 0, &tasks),
> the otime can be updated after several conditions checking.
The update is performed now performed inside perform_atomic_semop():

Old code:
perform_atomic_semop() does not update sem_otime. It just returns 0 for 
successfull operations.
This "0 returned" is passed upwards ("semop_completed") into 
do_smart_update()
do_smart_update() updates sem_otime.

New code:
perform_atomic_semop() updates sem_otime immediately (your change).
No need to keep track if a waiting operation was completed (my change).

I don't see a problem - perhaps I overlook something.
Which problem do you see?

--
     Manfred

