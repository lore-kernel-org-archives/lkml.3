Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaGJAhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:37:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbaGJAhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:37:37 -0400
Date: Wed, 9 Jul 2014 17:42:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH char-misc-next v2 2/8] misc: mic: add a bus driver for
 virtual MIC devices
Message-ID: <20140710004202.GC4950@kroah.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
 <6e4394a52ccac7bbd16450ace82b2c1a118440e0.1401397315.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e4394a52ccac7bbd16450ace82b2c1a118440e0.1401397315.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 02:23:59PM -0700, Sudeep Dutt wrote:
> +/**
> + * mbus_device - representation of a device using mbus
> + * @priv: private pointer for the driver's use.
> + * @mmio_va: virtual address of mmio space
> + * @hw_ops: the hardware ops supported by this device.
> + * @id: the device type identification (used to match it with a driver).
> + * @dev: underlying device.
> + * be used to communicate with.
> + * @index: unique position on the mbus bus
> + */
> +struct mbus_device {
> +	void *priv;

What's wrong with the built-in "private" pointer that struct device has?
That is why it is there...

> +	void __iomem *mmio_va;
> +	struct mbus_hw_ops *hw_ops;
> +	struct mbus_device_id id;
> +	struct device dev;
> +	int index;
> +};

