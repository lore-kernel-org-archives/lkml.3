Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaAaXIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:08:30 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41455 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbaAaXI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:08:29 -0500
From: "Network Nut" <sillystack@gmail.com>
To: "'Clemens Ladisch'" <clemens@ladisch.de>
Cc: "'Austin S. Hemmelgarn'" <ahferroin7@gmail.com>,
        <linux-kernel@vger.kernel.org>
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com> <52E77282.4030303@ladisch.de> <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com> <95b6e508-1358-4f01-9687-344e25bd4b2b@email.android.com> <00f201cf1e15$f134ce70$d39e6b50$@gmail.com> <52EBD7BC.5020704@gmail.com> <007d01cf1ed4$b0e659a0$12b30ce0$@gmail.com> <52EC297B.7080909@ladisch.de> <007f01cf1ed8$3b8e1450$b2aa3cf0$@gmail.com>
In-Reply-To: <007f01cf1ed8$3b8e1450$b2aa3cf0$@gmail.com>
Subject: RE: WaitForMultipleObjects/etc. In Kernel
Date: Fri, 31 Jan 2014 17:08:25 -0600
Message-ID: <008101cf1ed9$588966d0$099c3470$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQNT3acP/4y+UoGLob+8VizidhBl0AFz54/xAX6FO6UBfOQBmQGmz+ZcAX4/+oICHvy7eQGGlUFQAlIvzyACA4NB4wIIYUjqAlBcClgBKyzVFJbtWk9A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Network Nut [mailto:sillystack@gmail.com]
> Sent: Friday, January 31, 2014 5:00 PM
> To: 'Clemens Ladisch'
> Cc: 'Austin S. Hemmelgarn'; linux-kernel@vger.kernel.org
> Subject: RE: WaitForMultipleObjects/etc. In Kernel
> > -----Original Message-----
> > From: Clemens Ladisch [mailto:clemens@ladisch.de]
> > Sent: Friday, January 31, 2014 4:54 PM
> > To: Network Nut
> > Cc: 'Austin S. Hemmelgarn'; linux-kernel@vger.kernel.org
> > Subject: Re: WaitForMultipleObjects/etc. In Kernel
> >
> > Network Nut wrote:
> > >> Assuming that you're porting to mainline distributions (and not
> > >> embedded devices), named SHM segments are accessible (providing
> the
> > >> accessing process has correct permissions) under /dev/shm.  You
> > >> just need to make sure that you create the segment with the right
> > >> permissions for the other processes to access it.
> > >
> > > I already know how to do named shared memory between two
> processes.
> > I only included that to describe my overall problem.
> > >
> > > The problem that I am having is how I can make three
> > > totally-independent
> > processes interact:
> > >
> > > 1. M is a master process that creates a semaphore.
> > > 2. P1 is a process that operates against the semaphore.
> > > 3. P2 is a process that operates against the semaphore.
> > > 4. It is not permissible that M be responsible for launching P1 or P2.
> > > 5.  The semaphore, one way or another, must allow itself to be
> > > specified as one of the synchronization primitives in epoll_wait()
> >
> > This general problem descripton does not say anything more than your
> > first mail.
> >
> > Use eventfd.  To share it, use a Unix domain socket created by M.
> > (This socket must be created at a well-known path.  shm_open() works
> > similarly, but that it creates a file in a RAM disk and mmap()s it is
> > just an implementation detail.)
> 
> How do I create the socket at "well-known path"?

Nevermind. I see it. 

It is the sockaddr_un.sun_path.

Thanks!

-Nut




