Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaA3Xtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:49:45 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61117 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaA3Xtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:49:43 -0500
From: "Network Nut" <sillystack@gmail.com>
To: "'Clemens Ladisch'" <clemens@ladisch.de>
Cc: <linux-kernel@vger.kernel.org>
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de> <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com> <52E6219A.3020405@ladisch.de> <00d001cf1b99$026407d0$072c1770$@gmail.com> <52E77282.4030303@ladisch.de> <009701cf1c6c$fbfaff50$f3f0fdf0$@gmail.com> <95b6e508-1358-4f01-9687-344e25bd4b2b@email.android.com>
In-Reply-To: <95b6e508-1358-4f01-9687-344e25bd4b2b@email.android.com>
Subject: RE: WaitForMultipleObjects/etc. In Kernel
Date: Thu, 30 Jan 2014 17:49:39 -0600
Message-ID: <00f201cf1e15$f134ce70$d39e6b50$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQNT3acP/4y+UoGLob+8VizidhBl0AFz54/xAX6FO6UBfOQBmQGmz+ZcAX4/+oICHvy7eQGGlUFQlzqd5SA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Clemens Ladisch [mailto:clemens@ladisch.de]
> Sent: Wednesday, January 29, 2014 2:31 AM
> To: Network Nut
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: WaitForMultipleObjects/etc. In Kernel
> 
> Network Nut wrote:
> >I was looking at POSIX because it allows naming of the primitives.
> 
> Linux uses two orthogonal mechanisms for synchronization primitives and for
> naming/sharing.
> 
> >I need to epoll_wait on inter-process {mutex, event, semaphore}.
> 
> Use eventfd.
> 
> >I need to reference inter-process {mutex, event, semaphore}, each
> >identified by string, if feasible.
> 
> Send the fd through a Unix domain socket.

Hi Again,

I was thinking that, rather than as for specifics, I should present my general problem, and ask how long-time Linux experts would solve it.

I have a master process M, that executes continually, from the birth to death of user-session.

I have many (distinct) processes that will be launched, and these processes, P1, P2, ...Pn, expect to see that M is executing. These processes:

1. expect to have access to a shared-memory section that already exists because M created it
2. expect to use a semaphore that already exists because M created it
3. expect to use a mutex that exists because M created it

P1, P2, ...Pn all know the path of image on disk of M. They are also permitted to maintain a fixed string that can be used to "get at" the mutex and semaphore.

How would P1, P2, ...Pn get at the semaphore that M created?

Please note that M cannot have any prior knowledge at all of P1, P2, ...Pn. P1...etc. must initiate  communication with M.

[I don't want to misuse/abuse linux-kernel with my personal questions, so if there is a more appropriate group, please let me know.]

Regards,

-Net



