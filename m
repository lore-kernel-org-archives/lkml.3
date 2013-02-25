Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab3BYD7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:59:39 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:50849 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab3BYD7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:59:37 -0500
Date: Sun, 24 Feb 2013 20:00:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, thierry.reding@avionic-design.de, rob@landley.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC] pwm: add sysfs interface
Message-ID: <20130225040025.GB7911@kroah.com>
References: <1361284061-2874-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361284061-2874-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 03:27:41PM +0100, Lars Poeschel wrote:
> +static int pwmchip_export(struct pwm_chip *chip)
> +{
> +	int status;
> +	struct device *dev;
> +
> +	mutex_lock(&sysfs_lock);
> +	dev = device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
> +				"pwmchip%d", chip->base);
> +	if (!IS_ERR(dev))
> +		status = sysfs_create_group(&dev->kobj, &pwmchip_attr_group);
> +	else
> +		status = PTR_ERR(dev);

You can't create sysfs files after the device has been exposed to
userspace.  Please use the default group functionality for the class,
which fixes this problem.

thanks,

greg k-h
