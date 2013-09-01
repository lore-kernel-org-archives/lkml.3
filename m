Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab3IASBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 14:01:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3IASBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 14:01:41 -0400
Date: Sun, 1 Sep 2013 11:01:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] hwmon: Introduce hwmon_device_register_with_groups
Message-ID: <20130901180140.GA13735@kroah.com>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
 <1378003742-18685-2-git-send-email-linux@roeck-us.net>
 <20130901162441.GB32712@kroah.com>
 <52237F96.2090008@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52237F96.2090008@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 10:55:34AM -0700, Guenter Roeck wrote:
> On 09/01/2013 09:24 AM, Greg Kroah-Hartman wrote:
> >This looks good, just one minor question about the
> >non-driver-core-related code:
> >
> >>+struct device *
> >>+hwmon_device_register_with_groups(struct device *dev, const char *name,
> >>+				  void *drvdata,
> >>+				  const struct attribute_group **groups)
> >>  {
> >>-	struct device *hwdev;
> >>-	int id;
> >>+	struct hwmon_device *hwdev;
> >>+	int err, id;
> >>
> >>  	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
> >>  	if (id < 0)
> >>  		return ERR_PTR(id);
> >
> >Don't you need a lock around the ida_simple_get call to ensure hwmon_ida
> >is not being used at the same time twice?  Or does the ida framework
> >handle that ok?
> >
> 
> ida_simple_get handles the locking as far as I can see. Other callers don't use
> local locks either, so I guess it must be working.

Ok, nevermind then, nice work.

greg k-h
