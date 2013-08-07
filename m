Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3HGViZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:38:25 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:41142 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3HGViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:38:24 -0400
Message-ID: <5202BE4E.6010908@linuxtoys.org>
Date: Wed, 07 Aug 2013 14:38:22 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com>
In-Reply-To: <20130806094604.GE27889@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
 >> 	echo 1 > /proc/sys/net/ipv4/ip_forward  # procfs
 >> 	echo 75 > /dev/motors/left/speed        # proxy
 >> 	echo 5 > /dev/wpa_supplicant/use_channel # proxy
 > No it shouldn't, that is userspace talking to the kernel, you aren't
 > doing that at all.

You are correct. But it's not _what_ is being done, it's _how_.
Procfs clients have a really simple way of sending data to the kernel
	open(ip_forward)
	write("1\n")
	close
I want the same thing for my user space daemon
	open(speed)
	write("75\n")
	close

 >
 >> new IPC must have the following characteristics:
 >> 	- bidirectional
 >> 	- writer blocks until reader is present
 >> 	- a writer can cause the reader to close
 >> 	- works with 'echo' and 'cat'
 > Who is saying "must" here?  Why are those requirements at all?

I could be wrong but to accomplish an open/write/close interface
sort of like sysfs or procfs, I think we need an IPC that is
	- visible as a file name
	- bidirectional
	- both ends much be connected to communicate
	- a writer can effectively send EOF through the device

 >
 > Specifically how would someone would use this to write a userspace
 > driver?  I'm totally not seeing it at all, and possibly, that's why I am
 > so confused.

Hopefully the sample program I sent earlier makes sense.
The source of data in the sample program was time of day
but it could have as easily been date from a USB serial
device or from a generic i2c device.

 >
 >>    Finally, some device drivers that are not possible today
 >> would become possible.  In my case I have a USB-serial link
 >> to a robot controller and so need a user space daemon to
 >> terminate the serial line.  It is only with proxy that I
 >> can hide the details of this and give users a nice /dev
 >> view of the robot.
 > How specifically would you do this with such a usb-serial device?

Again, I hope the sample program makes this easier to see.

 >
 >> USE CASE #2:  End the madness of per-language bindings
 > The kernel doesn't deal with language bindings, it provides a syscall
 > interface that any language can call, or not, it's up to them.  So this
 > really isn't relevant at all.

Agreed.  But isn't every IPC or other feature in the kernel
there because someone in user space needed it?  I hope so.

 >
 > ASCII isn't all that its cracked up to be, you should know better than
 > that :)
 > And why ASCII?  Why not XML?  :)

You are entirely correct here.


thanks
Bob Smith
