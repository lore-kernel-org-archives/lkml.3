Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaGJQup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:50:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:15206 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaGJQun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:50:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,638,1400050800"; 
   d="scan'208";a="541537127"
Subject: Re: [PATCH char-misc-next v2 2/8] misc: mic: add a bus driver for
 virtual MIC devices
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
In-Reply-To: <20140710004202.GC4950@kroah.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
	 <6e4394a52ccac7bbd16450ace82b2c1a118440e0.1401397315.git.sudeep.dutt@intel.com>
	 <20140710004202.GC4950@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jul 2014 09:43:42 -0700
Message-ID: <1405010622.10161.34.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 17:42 -0700, Greg Kroah-Hartman wrote:
> On Thu, May 29, 2014 at 02:23:59PM -0700, Sudeep Dutt wrote:
> > +/**
> > + * mbus_device - representation of a device using mbus
> > + * @priv: private pointer for the driver's use.
> > + * @mmio_va: virtual address of mmio space
> > + * @hw_ops: the hardware ops supported by this device.
> > + * @id: the device type identification (used to match it with a driver).
> > + * @dev: underlying device.
> > + * be used to communicate with.
> > + * @index: unique position on the mbus bus
> > + */
> > +struct mbus_device {
> > +	void *priv;
> 
> What's wrong with the built-in "private" pointer that struct device has?
> That is why it is there...
> 

We were using both mbus_device priv and the device driver_data fields
unnecessarily. I have a patch which gets rid of the mbus_device priv
field and uses only the device driver_data field via
dev_set/get_drvdata(..). The next revision of the patch series will have
this cleaned up.

Thanks for the review!

Sudeep Dutt

> > +	void __iomem *mmio_va;
> > +	struct mbus_hw_ops *hw_ops;
> > +	struct mbus_device_id id;
> > +	struct device dev;
> > +	int index;
> > +};
> 


