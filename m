Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031662Ab3HIXfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:35:16 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:32833 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031637Ab3HIXfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:35:14 -0400
Message-ID: <52057CB4.2020603@linuxtoys.org>
Date: Fri, 09 Aug 2013 16:35:16 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com> <5202B674.7060005@linuxtoys.org> <20130807213325.GB5373@kroah.com> <520569B2.4000704@linuxtoys.org> <20130809230150.GA23418@kroah.com>
In-Reply-To: <20130809230150.GA23418@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> Good protocols exist, look at protobufs from Google if you want to
> define your own.  Never create your own protocol these days, it doesn't
> make sense, be it a text one or something else.

OK.  I was using the term in the broader sense in which _meaning_ is
assigned to the data in the protocol, not just the data marshaling.

>
>> - a C _binding_ to present a C API and hide the protocol for C programmers,
>> - a C++ binding and API for C++ programmers
>> - a Java binding
>> - a PHP binding
>> - a Perl binding
>> - a Python binding
>> - a node.js binding
>> - a Scratch binding for Raspberry Pi users
>> - and some kind of shell binding for Bash programmers
> All of those languages already support Linux syscalls, no need to create
> anything else.
Yes, we can publish the protocol and let the application writer
deal with it.  Bindings are nice only if you want to give a simple
API to the developer or want to hide the details of the protocol.

>
>>  From a kernel developer's point of view the term "userspace driver"
>> may seem like an oxymoron.  By definition, all devices on the system
>> have to be controlled by the kernel.  All else is just userspace.
>
> Not true at all, I know all about userspace drivers, look at the UIO
> code in the Linux kernel.  It was created explicitly for this exact
> thing, and to prevent the myrads of broken implementations from being
> created again and again and again.  Just use it if you wish to talk to
> your hardware directly, lots of people do so.
Well, not this exact thing.  UIO is great if your hardware hangs
on a bus directly connected to the CPU.  It does nothing to help
the case of hardware connected over some communications link.

>
>> As an _opinion_ only, I think maybe userspace device drivers do exist.
>> It refers to  hardware that the kernel is not, and should not, be aware
>> of.  This hardware is not seen because it is at the end of some kind of
>> communications channel like USB-serial or Ethernet. A developer might
>> like to view that hardware as part of the overall system even if Linux
>> and the CPU do not have direct access to it.  A userspace driver looks
>> something like this
>>
>> 	=(ProxyDevNode)====(daemon)===(CommChannel)===(hardware)
>
> Not really, you are just using an IPC to talk to a "real" device driver.

Yes, each of the "=" above has data passing through a real driver.

>
> FPGAs are interesting things, people are creating "real" drivers for
> them (see the linux-kernel archives for a few examples.)  Other people
> just use the UIO layer instead, which works quite well for them.  I
> suggest you do the same thing.

UIO can not see hardware at the end of a USB-serial link.

>
> Again, you are creating a new form of userspace/userspace IPC, without a
> good reason for why one of the existing IPC implementations will not
> work for you (no, being able to use "echo" is not a good reason, you can
> do that with local sockets just fine).
>
> I suggest you take a look at the book, The Linux Programming Interface,
> by Michael Kerrisk, specifically chapter 43, which goes into great
> detail about all of the existing IPC mechanisms that Linux already
> provides.  I'm sure one of them should be able to fit your needs.

Greg Kroah-Hartman wrote:
> Otherwise, to accept this code, I need to see a way that normal users
> can use it (i.e. no root or mknod), and that it can handle namespaces
> and the security interface that the kernel has to support.  To do so
> otherwise would be unfair to users who expect such a thing.

OK, this makes sense.

thanks
Bob Smith




