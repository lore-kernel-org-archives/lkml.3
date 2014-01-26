Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaAZWKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 17:10:20 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47096 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaAZWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 17:10:19 -0500
From: "Network Nut" <sillystack@gmail.com>
To: "'Clemens Ladisch'" <clemens@ladisch.de>
Cc: <linux-kernel@vger.kernel.org>
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com> <52E554EC.3090900@ladisch.de>
In-Reply-To: <52E554EC.3090900@ladisch.de>
Subject: RE: WaitForMultipleObjects/etc. In Kernel
Date: Sun, 26 Jan 2014 16:10:16 -0600
Message-ID: <012d01cf1ae3$6543e340$2fcba9c0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQNT3acP/4y+UoGLob+8VizidhBl0AFz54/xl4JiyYA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Clemens Ladisch [mailto:clemens@ladisch.de]
> Sent: Sunday, January 26, 2014 12:33 PM
> To: Network Nut
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: WaitForMultipleObjects/etc. In Kernel
> 
> Network Nut wrote:
> > I think that the facility by which a thread can block while waiting
> > for any of several synchronization primitives (*mutex*, *semaphore*,
> > *event*, *waitable timer*)...is not only "nice to have", but
> > fundamental to complex (clean) multi-threaded programming.
> 
> You mean a facility like (e)poll, which can wait for things like timerfd,
signalfd,
> or eventfd?
> 
> 
> Regards,
> Clemens

Yes, that seems to be what I am looking for.

I have a concern:

As you know, under Windows, synchronization objects such as {event | mutex |
semaphore | timer}; all have names that are computer-global. Process B can
open, and use, any {event | mutex | semaphore | timer} that was created by
process A, as long as Process B knows the name that was used by Process A to
create the {event | mutex | semaphore | timer}. These synchronization
objects may also be nameless if the programmer so chooses, in which case,
process B would have to use a circuitous method to determine how to find the
kernel-object created by Process A.

Is there a method I can use where Process A and Process B can both refer to
the same eventfd by name?

BTW, the man page for epoll_wait seems to be incorrect. It says:

"The timeout argument specifies the minimum number of milliseconds
       that epoll_wait() will block."

I think the word "minimum" should be "maximum".

Regards,

-Nut



