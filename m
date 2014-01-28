Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbaA1VHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:07:48 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48137 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaA1VHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:07:46 -0500
From: "Network Nut" <sillystack@gmail.com>
To: "'Clemens Ladisch'" <clemens@ladisch.de>
Cc: <linux-kernel@vger.kernel.org>
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com> <52E77282.4030303@ladisch.de>
In-Reply-To: <52E77282.4030303@ladisch.de>
Subject: RE: WaitForMultipleObjects/etc. In Kernel
Date: Tue, 28 Jan 2014 15:07:41 -0600
Message-ID: <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQNT3acP/4y+UoGLob+8VizidhBl0AFz54/xAX6FO6UBfOQBmQGmz+ZcAX4/+oKXVHkP0A==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Clemens Ladisch [mailto:clemens@ladisch.de]
> Sent: Tuesday, January 28, 2014 3:04 AM
> To: Network Nut
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: WaitForMultipleObjects/etc. In Kernel
> 
> Network Nut wrote:
> > 5. I can simulate system-global named mutex using shared-memory for
> > underlying state of mutex (POCO NamedMutex) 6. I can get named
> > semaphore using POSIX sem_create
> >
> > It seems that the remaining problem is to get named mutex and named
> > semaphore to be accessible by file-descriptor.
> 
> Forget about the POSIX stuff.  You can implement a mutex by using an
> eventfd that has the value 1 in the unlocked state; a read locks, a write
of 1
> unlocks.  You can implement a semaphore by using an eventfd with
> EFD_SEMAPHORE.

I was looking at POSIX because it allows naming of the primitives.

I need to reference inter-process {mutex, event, semaphore}, each identified
by string, if feasible.
I need to epoll_wait on inter-process {mutex, event, semaphore}.

> And I should note that it is a common pattern to start a bunch of other
> processes from a helper process; this not only allows inheriting file
> descriptors, but also makes monitoring these processes easier from the
> parent.  Do all of your processes really need to be started independently?

Yes, all my processes need to be started independently. 

Regards,

-Net


