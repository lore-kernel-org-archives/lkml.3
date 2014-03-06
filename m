Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaCFEnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:43:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbaCFEnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:43:11 -0500
Date: Wed, 5 Mar 2014 20:43:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Ringle <jon@ringle.org>
Cc: "Ringle, Jonathan" <Jonathan.Ringle@gridpoint.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add option to build with -O3
Message-ID: <20140306044337.GB5722@kroah.com>
References: <1393977709-9809-1-git-send-email-jringle@gridpoint.com>
 <20140305050927.GA8534@kroah.com>
 <alpine.DEB.2.02.1403050230120.24331@jringle-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403050230120.24331@jringle-ubuntu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 02:32:26AM -0500, Jon Ringle wrote:
> On Wed, 5 Mar 2014, Greg KH wrote:
> 
> > On Tue, Mar 04, 2014 at 07:01:49PM -0500, Jon Ringle wrote:
> > > +config CC_OPTIMIZE_FOR_SPEED
> > > +    bool "Optimze for speed (-O3)"
> > > +    help
> > > +      Enabling this option will pass "-O3" to gcc
> > > +      resulting in a larger kernel (but possibly faster)
> > 
> > Are you sure about that?  Have you measured it?
> 
> (Resending this message, since it was "destroyed". Hopefully, this is now 
> an an acceptable form :)
> 
> I do know that there is an improvement performance-wise for my particular 
> use-case.
> 
> My target is an ARM board being built with gcc-4.8.2. My board has on it a 
> sc16is740 that is used as an RS-485 port. The sc16is740 is on the i2c bus, 
> so when an interrupt comes in to indicate that there is data available to 
> be read, I need to get the data over the i2c bus. I do this on a kthread 
> to do this work. The i2c transactions (using i2c-davinci driver) are also 
> interrupt driven. I was seeing a lot of lost packets when receiving data 
> at only 19200. Adding the -O3 compile option helped in this regard in that 
> I am now rarely seeing packet loss.

I'd take this up with the linux-arm developers, that sounds like
something is wrong with your system that a compiler change fixes
problems.  Something else must be wrong...

good luck,

greg k-h
