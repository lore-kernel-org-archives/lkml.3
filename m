Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab3HNTPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:15:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab3HNTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:15:14 -0400
Date: Wed, 14 Aug 2013 12:15:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, tobetter@gmail.com, patches@linaro.org
Subject: Re: [PATCH] usb: misc: usb3503: Force late initialization
Message-ID: <20130814191513.GA24873@kroah.com>
References: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
 <20130814182239.GC23847@kroah.com>
 <20130814190410.GO2401@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814190410.GO2401@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 08:04:10PM +0100, Mark Brown wrote:
> On Wed, Aug 14, 2013 at 11:22:39AM -0700, Greg KH wrote:
> > On Wed, Aug 14, 2013 at 03:59:31PM +0530, Tushar Behera wrote:
> 
> > > Currently there is no other way to ensure that USB3503 chip is probed
> > > after the USB PHY has been initialized, hence the last resort.
> 
> > Are you sure that deferred probing doesn't solve this issue?
> 
> In order for deferred probing to help the device would need to acquire
> some resource from the parent USB controller once active, allowing it to
> defer when it fails to get that resource.  Currently there's nothing
> there for that and it's not clear that's sane and sensible (it'd be more
> obvious for it to be a child of the USB controller since that's what it
> really is).

Then why not do that?

> We can't just treat it as a PHY (which is the obvious workaroud) since
> we do also need to use the built
> in PHY in the SoC.

There has to be some type of resource that it can grab, as obviously
it's failing to work properly unless that resource is present.  Just
messing with the init order isn't going to solve any problem if the
driver is built as a module, as nothing guarantees module load order.

So this patch wouldn't really solve the problem, only paper over it for
one type of configuration (i.e. driver built into the system), right?

thanks,

greg k-h
