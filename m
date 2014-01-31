Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbaAaWyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:54:10 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:53948 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313AbaAaWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:54:08 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52EC297B.7080909@ladisch.de>
Date: Fri, 31 Jan 2014 23:53:47 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Network Nut <sillystack@gmail.com>
CC: "'Austin S. Hemmelgarn'" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: WaitForMultipleObjects/etc. In Kernel
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com> <52E77282.4030303@ladisch.de> <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com> <95b6e508-1358-4f01-9687-344e25bd4b2b@email.android.com> <00f201cf1e15$f134ce70$d39e6b50$@gmail.com> <52EBD7BC.5020704@gmail.com> <007d01cf1ed4$b0e659a0$12b30ce0$@gmail.com>
In-Reply-To: <007d01cf1ed4$b0e659a0$12b30ce0$@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network Nut wrote:
>> Assuming that you're porting to mainline distributions (and not embedded
>> devices), named SHM segments are accessible (providing the accessing
>> process has correct permissions) under /dev/shm.  You just need to make
>> sure that you create the segment with the right permissions for the
>> other processes to access it.
>
> I already know how to do named shared memory between two processes. I only included that to describe my overall problem.
>
> The problem that I am having is how I can make three totally-independent processes interact:
>
> 1. M is a master process that creates a semaphore.
> 2. P1 is a process that operates against the semaphore.
> 3. P2 is a process that operates against the semaphore.
> 4. It is not permissible that M be responsible for launching P1 or P2.
> 5.  The semaphore, one way or another, must allow itself to be specified as one of the synchronization primitives in epoll_wait()

This general problem descripton does not say anything more than your first
mail.

Use eventfd.  To share it, use a Unix domain socket created by M.  (This
socket must be created at a well-known path.  shm_open() works similarly,
but that it creates a file in a RAM disk and mmap()s it is just an
implementation detail.)


Regards,
Clemens
