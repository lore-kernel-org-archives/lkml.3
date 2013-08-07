Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab3HGTxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:53:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab3HGTxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:53:07 -0400
Date: Wed, 7 Aug 2013 12:54:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130807195427.GB4121@kroah.com>
References: <51FC5478.40500@linuxtoys.org>
 <51FC5A97.1090102@linuxtoys.org>
 <20130803223828.GA14611@kroah.com>
 <51FECDA6.5070001@linuxtoys.org>
 <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202A284.7010106@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 12:39:48PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
> >>  *    sudo chmod 666 /dev/proxyout /dev/proxyctrl
> >That's mighty permissive :(
> For a demo it might be OK.
> 
> BUT: I think I should modify the module to forward a close request
> (write 0 bytes) only if the sender UID matched the proxy node's UID.
> This might not be strictly required but is a security nice to have.
> 
> 
> >>  *    gcc -o pxtest pxtest.c
> >>  *    ./pxtest &
> >>  *    cat /dev/proxyout    # view the output
> >>  *    (switch to another terminal window)
> >>  *    cat /dev/proxyctrl   # what is the offset?
> >>  *    echo 2 > /dev/proxyctrl  # set offset to 2
> >>  */
> >
> >I really don't understand this, you just have two programs talking to
> >each other, passing the data blindly through the kernel.  Again, we
> >already have over 10 different ways to do IPC these days, are you _sure_
> >that _none_ of them work for you like this?  You have gone and looked at
> >them all, right?
> 
> All along I've had a clear goal.  I want to configure a running program
> the same way I configure the kernel.  It is simple and I don't need any
> language bindings.
> 	cat /dev/proxyctrl   # what is the offset?
> 	echo 2 > /dev/proxyctrl  # set offset to 2

You have language bindings right there in bash for this api, what you
are saying is that you don't want to write new syscall bindings for new
languages, which is fine, don't do that, use the ones we already have
for the vast number of different IPC types.

> Yes, I am sure that nothing else will do.  A named pipe is the closest
> but it has a buffer and is not bidirectional.   I am also convinced that
> there is no way to do what I want with fewer lines of code.

What is your specific requirements, I see you couch them in terms of
what you have created, but none in terms of actual requirements with no
specific implementation.

And all of my other outstanding questions still remain, please address
those as well.

thanks,

greg k-h
