Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750750Ab3IFEw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:52:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3IFEwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:52:20 -0400
Date: Thu, 5 Sep 2013 21:55:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH RESEND v3 1/7] Intel MIC Host Driver for X100 family.
Message-ID: <20130906045503.GB28806@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
 <8b972a444f4529ecffc718db4112aa8959bf72ad.1378423596.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b972a444f4529ecffc718db4112aa8959bf72ad.1378423596.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very minor nits, you can change this in a future add-on patch:

> +static DEVICE_ATTR(family, S_IRUGO, mic_show_family, NULL);

This should use DEVICE_ATTR_RO(), so that we don't have to audit the
permissions of your DEVICE_ATTR() files.

> +static DEVICE_ATTR(stepping, S_IRUGO, mic_show_stepping, NULL);

Same here.

> +static struct attribute *mic_default_attrs[] = {
> +	&dev_attr_family.attr,
> +	&dev_attr_stepping.attr,
> +
> +	NULL
> +};
> +
> +static struct attribute_group mic_attr_group = {
> +	.attrs = mic_default_attrs,
> +};
> +
> +static const struct attribute_group *__mic_attr_group[] = {
> +	&mic_attr_group,
> +	NULL
> +};

These last two structures can be replaced with:
ATTRIBUTE_GROUPS(mic_default);

> +void mic_sysfs_init(struct mic_device *mdev)
> +{
> +	mdev->attr_group = __mic_attr_group;
> +}

This is "odd", why not just export the data structure and reference it
in the other code?  The pci core does this, and so do other busses.

Anyway, it's not a big deal, just a bit strange to me.

thanks,

greg k-h
