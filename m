Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3HLWx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:53:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3HLWx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:53:56 -0400
Date: Mon, 12 Aug 2013 15:53:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: akhil.goyal@freescale.com
Cc: arnd@arndb.de, lars@metafoo.de, robin.getz@analog.com,
        Michael.Hennerich@analog.com, lars-peter.clausen@analog.com,
        linux-kernel@vger.kernel.org, pankaj.chauhan@freescale.com
Subject: Re: [PATCH v2 1/4] drivers/misc: Support for RF interface device
 framework
Message-ID: <20130812225354.GA30734@kroah.com>
References: <1376291633-4682-1-git-send-email-akhil.goyal@freescale.com>
 <1376291633-4682-2-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376291633-4682-2-git-send-email-akhil.goyal@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 12:43:50PM +0530, akhil.goyal@freescale.com wrote:
> From: Akhil Goyal <akhil.goyal@freescale.com>
> 
> The radio device framework introduces a way to accommodate the
> RF(radio frequency) signal paths.  One signal path is represented
> as a RF device (rf0, rf1 etc), and it can contain multiple
> components which have their individual vendor specific drivers.
> The framework provides mechanism by which individual components
> can register with RF framework, and the framework will handle the
> binding of individual component devices to a RF device. RF device
> exports the control interfaces to user space, and this user space
> interface is independent of component (vendor specific) drivers.
> 
> In a multimode system there can be multiple rfdev devices, depending
> on number of radios connected.
> 
> In this patch, the rf controller(AIC) and RFIC drivers
> register their respective devices with this framework. This framework
> does binding of RFIC device with RF controller device and exposes
> the combination as a logical rfdev to user space.

You are creating a bunch of character device nodes, yet there is no
"device" behind it yet.  Also, you do not export these to userspace at
all, so no "modern" system can access these device nodes at all (hint,
try this on your desktop system...)

You should really tie into the driver model properly, to get the device
node creation, as well as showing to userspace exactly which devices is
connected on the "rf bus" that you need to create, because you have a
bunch of different devices that can be attached here, with no real way
to show userspace what is going on.

Please fix up the code to do this, as it is, this is not mergable at
all.  And I'm finding it hard to understand how you tested it out...

thanks,

greg k-h
