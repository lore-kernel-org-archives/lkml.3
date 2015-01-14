Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbbANQd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:33:28 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:44907 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbANQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:33:26 -0500
Date: Wed, 14 Jan 2015 16:33:17 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Siddhartha De <siddhartha.de87@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about kernel interfaces
Message-ID: <20150114163317.46a1ecec@lxorguk.ukuu.org.uk>
In-Reply-To: <CADxyqME4=vnZh4J8BDw63r6L=hA8OpO4GJWxuuOgwuFwHb+8Lg@mail.gmail.com>
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com>
	<CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com>
	<20150108134849.671ee761@lxorguk.ukuu.org.uk>
	<CADxyqME4=vnZh4J8BDw63r6L=hA8OpO4GJWxuuOgwuFwHb+8Lg@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just wanted to point out something  :-
> 
> Quoting from makelinux website :-
> http://www.makelinux.net/books/lkd2/ch17lev1sec8
> 
> "The sysfs filesystem is currently the place for implementing
> functionality previously reserved for ioctl() calls on device nodes or
> the procfs filesystem. These days, the chic thing to do is implement
> such functionality as sysfs attributes in the appropriate directory.
> For example, instead of a new ioctl() on a device node, add a sysfs
> attribute in the driver's sysfs directory. Such an approach avoids the
> type-unsafe use of obscure ioctl() arguments and the haphazard mess of
> /proc. "

And is wrong. Certainly rather clueless people had the idea they could
make ioctl go away using sysfs, and then everyone wrote about it. Anyone
who actually thought about the problem realised immediately they are not
semantically equivalent.

> sysfs is the new ioctl

And as was pointed out even then they are not semantically equivalent so
everyone who was talking about "sysfs being the new ioctl" was basically
talking out the wrong end.

What was done was to stop filling drivers with ioctls for pieces of
general information which didn't have a context attached to it or
sequence. Things like power state, what type it is, what bus it is on
etc. That avoided having zillions of ioctls but at the cost of memory.

> Taking this idea further , could we also expose driver IOCTL's over
> the network ?
> 
> For eg to open the cd rom drive we would be calling the following url :-

You could but why would you make the network visible. If you look at real
clustered systems they all hide the network. You don't care where it is,
often you don't even care where the drive is.

eject /dev/cdrom

on such a system lets the kernel figure out who to ask to eject it.

The job of an OS is to abstract details like that. In a clustered OS I
want to be able to type

	mount mydisk

and I don't care who, where or how it gets mounted so long as it appears.

Alan
