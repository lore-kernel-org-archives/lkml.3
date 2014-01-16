Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaAPCaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:30:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaAPCaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:30:01 -0500
Date: Wed, 15 Jan 2014 18:30:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Chase Southwood <chase.southwood@yahoo.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
Message-ID: <20140116023040.GB31275@kroah.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
 <1389745385-27146-1-git-send-email-chase.southwood@yahoo.com>
 <20140115035849.GA13127@kroah.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8817E79783@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8817E79783@P3PWEX4MB008.ex4.secureserver.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:29:21PM +0000, Hartley Sweeten wrote:
> On Tuesday, January 14, 2014 8:59 PM, Greg KH wrote:
> > Sleep for at least 10, as I think that's the smallest time delay you can
> > sleep for anyway (meaning it will be that long no matter what number you
> > put there less than 10, depending on the hardware used of course.)
> 
> A bit off topic here but I have a somewhat related question about timeouts.
> 
> There are a number of comedi drivers that do a "wait for end-of-conversion"
> as part of the (*insn_read) for an analog input subdevice or (*insn_write) for
> an analog output subdevice. These functions return an errno if a timeout occurs.
> 
> Currently either -ETIME or -ETIMEDOUT is returned. This errno ends up getting
> returned to the user as the result of the unlocked_ioctl file operation. What is
> the more appropriate errno? Or is there is better one that should be used?

I think they should all be -ETIMEDOUT, -ETIME is used for something
else, and shouldn't be sent to userspace as I don't think it knows what
to do with it.

thanks,

greg k-h
