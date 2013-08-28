Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3H1S3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:29:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3H1S3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:29:19 -0400
Date: Wed, 28 Aug 2013 11:31:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Missing removal of sysfs attributes in gpiolib
Message-ID: <20130828183139.GA14627@kroah.com>
References: <20130828175717.GA7493@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828175717.GA7493@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 10:57:17AM -0700, Guenter Roeck wrote:
> Hi,
> 
> I noticed that gpiolib does not explicitly remove the sysfs attributes it
> created when exporting a gpio pin when the pin is unexported, ie when the
> associated device is removed.
> 
> Are those attributes auto-removed when device_unregister() is called ?

Yes they are.

> Sorry if this is a dumb question - I have not noticed this anywhere else,
> and I don't seem to be able to find the code actually performing auto-removal
> of manually created attributes, so I wonder if this is a bug or intentional.

Hm, I thought this was listed in the kobject.txt documentation file, but
I don't seem to find it there.

But, ideally you aren't creating individual attributes directly, you are
using attribute groups for the device, right?

thanks,

greg k-h
