Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3HGTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:25:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3HGTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:25:56 -0400
Date: Thu, 8 Aug 2013 04:27:14 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130807192714.GC2708@kroah.com>
References: <51FC5478.40500@linuxtoys.org>
 <51FC5A97.1090102@linuxtoys.org>
 <20130803223828.GA14611@kroah.com>
 <51FECDA6.5070001@linuxtoys.org>
 <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520299AB.1020607@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 12:02:03PM -0700, Bob Smith wrote:
> Greg
>    This sample program shows what I'm trying to accomplish.
> 
> I still owe you a reply for your previous posting
> 
> thanks
> Bob Smith
> 
> 
> /*
>  * pxtest.c : This program demonstrates the use of a proxy device.
>  *
>  * The program generates some data once a second and tries to send
>  * it to /dev/proxyout.  The original data is modified by adding
>  * an offset to each input character.  The offset can be set or
>  * viewed at the proxy device node /dev/proxyctrl.
>  *
>  * Typical usage might be
>  *    sudo modprobe proxy
>  *    PROXYDEV=`grep proxy /proc/devices | cut -d\  -f 1`
>  *    sudo mknod /dev/proxyout c $PROXYDEV 0
>  *    sudo mknod /dev/proxyctrl c $PROXYDEV 1

No one should ever have to mknod a device node, the kernel should do
this for us automatically, please don't regress to the 1990's...

>  *    sudo chmod 666 /dev/proxyout /dev/proxyctrl

That's mighty permissive :(

>  *    gcc -o pxtest pxtest.c
>  *    ./pxtest &
>  *    cat /dev/proxyout    # view the output
>  *    (switch to another terminal window)
>  *    cat /dev/proxyctrl   # what is the offset?
>  *    echo 2 > /dev/proxyctrl  # set offset to 2
>  */

I really don't understand this, you just have two programs talking to
each other, passing the data blindly through the kernel.  Again, we
already have over 10 different ways to do IPC these days, are you _sure_
that _none_ of them work for you like this?  You have gone and looked at
them all, right?

thanks,

greg k-h
