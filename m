Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3IYXCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:02:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3IYXCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:02:45 -0400
Date: Wed, 25 Sep 2013 16:02:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH] staging: dgrp: Convert to use device_create_with_groups
Message-ID: <20130925230244.GA4740@kroah.com>
References: <1377989766-7462-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377989766-7462-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 03:56:06PM -0700, Guenter Roeck wrote:
> Use device_create_with_groups to create sysfs attributes together with device.
> Also create class attribute together with class registration.
> This simplifies the code and ensures that attribute files exist when udev
> events are generated.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> I suspect that the 'register_with_sysfs' attribute exists to work around
> the problem solved with this patch. It doesn't make much sense otherwise.
> Can it be removed ?

All of these sysfs files can be removed, they shouldn't be there, as it
looks like they are used for odd configuration things.

And a single tty driver shouldn't be a "class" at all.

sorry,

greg k-h
