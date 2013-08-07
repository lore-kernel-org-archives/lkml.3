Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3HGTjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:39:51 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:60337 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab3HGTju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:39:50 -0400
Message-ID: <5202A284.7010106@linuxtoys.org>
Date: Wed, 07 Aug 2013 12:39:48 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com>
In-Reply-To: <20130807192714.GC2708@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
>>   *    sudo chmod 666 /dev/proxyout /dev/proxyctrl
> That's mighty permissive :(
For a demo it might be OK.

BUT: I think I should modify the module to forward a close request
(write 0 bytes) only if the sender UID matched the proxy node's UID.
This might not be strictly required but is a security nice to have.


>>   *    gcc -o pxtest pxtest.c
>>   *    ./pxtest &
>>   *    cat /dev/proxyout    # view the output
>>   *    (switch to another terminal window)
>>   *    cat /dev/proxyctrl   # what is the offset?
>>   *    echo 2 > /dev/proxyctrl  # set offset to 2
>>   */
>
> I really don't understand this, you just have two programs talking to
> each other, passing the data blindly through the kernel.  Again, we
> already have over 10 different ways to do IPC these days, are you _sure_
> that _none_ of them work for you like this?  You have gone and looked at
> them all, right?

All along I've had a clear goal.  I want to configure a running program
the same way I configure the kernel.  It is simple and I don't need any
language bindings.
	cat /dev/proxyctrl   # what is the offset?
	echo 2 > /dev/proxyctrl  # set offset to 2

Yes, I am sure that nothing else will do.  A named pipe is the closest
but it has a buffer and is not bidirectional.   I am also convinced that
there is no way to do what I want with fewer lines of code.

thanks
Bob Smith

