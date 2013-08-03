Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3HCSLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 14:11:50 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:41720 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3HCSLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 14:11:49 -0400
Message-ID: <51FD47F2.702@linuxtoys.org>
Date: Sat, 03 Aug 2013 11:12:02 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803023512.GA22635@kroah.com>
In-Reply-To: <20130803023512.GA22635@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg
    Thanks for your reply.  I'll reply to your comments in reverse order.


Greg Kroah-Hartman wrote:
> And how does this have anything to do with /sys?  I can't see any sysfs
> interaction in the code, or am I missing it?

Yes, you are right.  I'll change the subject and brief descriptions to
something like:
"Proxy, a simple bidirectional character device that almost transparently
proxies opens, reads, writes, and closes from one side of the device to
the other side."

I'll take "/sys" from all descriptions of the device, but I might leave it
in the Documentation/proxy.txt file since a major use case of proxy is to
give user space drivers and daemons the same kind of interface the kernel
enjoys with /sys and /proc.  The similarity is very deliberate on my part
for commands like
	echo 1 > /proc/sys/net/ipv4/ip_forward		# procfs
	echo 75 > /dev/motors/left/speed		# proxy dev




Greg Kroah-Hartman wrote:
 > Why not just use the cuse interface instead?  How does this differ from
 > that /dev node interaction?

I am a big fan of FUSE and CUSE but they do not support what I need.  CUSE
is OK if _ALL_ interaction is through its interface.  What is lacking is
an ability to open, say, a USB serial port and add its file descriptor to
CUSE's FD_SET.  This is a pretty deep problem since a CUSE takes away main()
from the application developer.  A CUSE application looks kind of like this:
	main(argc, argv)
	{
		(check and process command line)
		cuse_lowlevel_main(argc, argv, ...)
	}

Another difference is that no language bindings are needed.  There is no
equivalent of libfuse.so.  Since proxy is just a character device and there
are no language bindings, someone could, in the unlikely case it ever made
sense, write a user space device driver in node.js.


thanks
Bob Smith





