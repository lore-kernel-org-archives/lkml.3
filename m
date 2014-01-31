Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbaAaWfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:35:12 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37864 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaAaWfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:35:10 -0500
From: "Network Nut" <sillystack@gmail.com>
To: "'Austin S. Hemmelgarn'" <ahferroin7@gmail.com>,
        "'Clemens Ladisch'" <clemens@ladisch.de>
Cc: <linux-kernel@vger.kernel.org>
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com> <52E77282.4030303@ladisch.de> <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com> <95b6e508-1358-4f01-9687-344e25bd4b2b@email.android.com> <00f201cf1e15$f134ce70$d39e6b50$@gmail.com> <52EBD7BC.5020704@gmail.com>
In-Reply-To: <52EBD7BC.5020704@gmail.com>
Subject: RE: WaitForMultipleObjects/etc. In Kernel
Date: Fri, 31 Jan 2014 16:35:05 -0600
Message-ID: <007d01cf1ed4$b0e659a0$12b30ce0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQNT3acP/4y+UoGLob+8VizidhBl0AFz54/xAX6FO6UBfOQBmQGmz+ZcAX4/+oICHvy7eQGGlUFQAlIvzyACA4NB45cZb5Tg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Austin S. Hemmelgarn [mailto:ahferroin7@gmail.com]
> Sent: Friday, January 31, 2014 11:05 AM
> To: Network Nut; 'Clemens Ladisch'
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: WaitForMultipleObjects/etc. In Kernel

> >> Network Nut wrote:
> > I was thinking that, rather than as for specifics, I should present my general
> problem, and ask how long-time Linux experts would solve it.
> >
> > I have a master process M, that executes continually, from the birth to
> death of user-session.
> >
> > I have many (distinct) processes that will be launched, and these
> processes, P1, P2, ...Pn, expect to see that M is executing. These processes:
> >
> > 1. expect to have access to a shared-memory section that already exists
> because M created it
> > 2. expect to use a semaphore that already exists because M created it
> > 3. expect to use a mutex that exists because M created it
> >
> > P1, P2, ...Pn all know the path of image on disk of M. They are also
> permitted to maintain a fixed string that can be used to "get at" the mutex
> and semaphore.
> >
> > How would P1, P2, ...Pn get at the semaphore that M created?
> >
> > Please note that M cannot have any prior knowledge at all of P1, P2, ...Pn.
> P1...etc. must initiate  communication with M.
> >
> > [I don't want to misuse/abuse linux-kernel with my personal questions, so
> if there is a more appropriate group, please let me know.]
> >
> > Regards,
> >
> > -Net
> Assuming that you're porting to mainline distributions (and not embedded
> devices), named SHM segments are accessible (providing the accessing
> process has correct permissions) under /dev/shm.  You just need to make
> sure that you create the segment with the right permissions for the
> other processes to access it.

Thanks, Austin.

I already know how to do named shared memory between two processes. I only included that to describe my overall problem.

The problem that I am having is how I can make three totally-independent processes interact:

1. M is a master process that creates a semaphore.
2. P1 is a process that operates against the semaphore.
3. P2 is a process that operates against the semaphore.
4. It is not permissible that M be responsible for launching P1 or P2.
5.  The semaphore, one way or another, must allow itself to be specified as one of the synchronization primitives in epoll_wait()

How do I do this?

-Nut

