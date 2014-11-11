Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaKKIFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:05:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaKKIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:05:04 -0500
Date: Tue, 11 Nov 2014 17:03:44 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lauri Niskanen <ape@ape3000.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: misc: Add driver for ALVA Nanoface
Message-ID: <20141111080344.GA18131@kroah.com>
References: <1415689506-1755-1-git-send-email-ape@ape3000.com>
 <20141111070759.GA16276@kroah.com>
 <5461B7EF.2090308@ape3000.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5461B7EF.2090308@ape3000.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:17:03AM +0200, Lauri Niskanen wrote:
> On 11/11/14 09:07, Greg Kroah-Hartman wrote:
> >Any reason this can't be a simple userspace program that writes the
> >needed command to the device using libusb instead of being a kernel
> >driver?  This seems like overkill for a kernel driver to me.
> 
> You are probably right. It indeed should be possible to do this in
> userspace. I thought that having a kernel driver would still be benefical
> since it adds plug-and-play availability for all Linux users without having
> to deal with userspace driver programs.

You can do that by just providing a package that adds a udev rule to run
your program when the device is seen.

Yes, it's not as "easy" as being in the main kernel tree, but we do like
to keep things out of the kernel that don't have to be in the kernel.
We removed a number of drivers like this about 10 years go for that very
reaason.

> You are far more experienced with these things than me, so I am happy to let
> you make the decision about whether to have a kernel driver or not.

I think a userspace program would be best.

sorry,

greg k-h
