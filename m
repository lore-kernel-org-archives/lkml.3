Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaKKEKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:10:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaKKEKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:10:15 -0500
Date: Tue, 11 Nov 2014 13:08:56 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [V2 PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141111040856.GA22068@kroah.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 06:09:32PM -0800, Stephanie Wallick wrote:
> +static int mausb_bus_probe(struct device *dev)
> +{
> +	return mausb_probe(dev);
> +}
> +
> +static int mausb_bus_remove(struct device *dev)
> +{
> +	return mausb_remove(dev);
> +}

Wrapper functions that just call another function?  Why?

> +static void mausb_dev_release(struct device *dev)
> +{
> +	/* TODO: if we dynamically allocate anything, free it here */
> +}

As per the documentation in the kernel source tree[1], I am now allowed
to mock you mercilessly for thinking that you know more than the kernel,
and are just providing an "empty" function just to shut it up from
complaining about no release function at all.  Did you stop to think
about _why_ the kernel was warning you about this, and how would an
empty function solve anything?

Sorry, I can never accept code that does this in the kernel, even in
staging, which says a lot...

thanks,

greg k-h

[1] Documentation/kobject.txt, line 270
