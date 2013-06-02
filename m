Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3FBWiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 18:38:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab3FBWiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 18:38:16 -0400
Date: Sun, 2 Jun 2013 15:38:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] firewire: introduce fw_driver.probe and .remove methods
Message-ID: <20130602223843.GA7194@kroah.com>
References: <51A20AEE.7060201@sakamocchi.jp>
 <20130526233513.1a95d0d5@stein>
 <20130526225757.GA32606@kroah.com>
 <51A742A1.8010108@sakamocchi.jp>
 <20130603002749.4fdc36a5@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603002749.4fdc36a5@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 12:27:49AM +0200, Stefan Richter wrote:
> FireWire upper layer drivers are converted from generic
>     struct driver.probe() and .remove()
> to bus-specific
>     struct fw_driver.probe() and .remove().
> 
> The new .probe() adds a const struct ieee1394_device_id *id argument,
> indicating the entry in the driver's device identifiers table which
> matched the fw_unit to be probed.  This new argument is used by the
> snd-firewire-speakers driver to look up device-specific parameters and
> methods.  There is at least one other FireWire audio driver currently in
> development in which this will be useful too.
> 
> The new .remove() drops the unused error return code.
> 
> Although all in-tree drivers are being converted to the new methods,
> support for the old methods is left in place for the time being, aiming
> to avoid conflicts if/when new drivers are being merged into the
> mainline via other trees.

Are there other firewire drivers in other trees in linux-next right now?
If not, I'd just recommend converting everything over and not using the
old functions at all.  Especially as there really isn't that many
firewire drivers, and new ones are pretty rare these days, right?

Other than that, your patch looks good.

thanks,

greg k-h
