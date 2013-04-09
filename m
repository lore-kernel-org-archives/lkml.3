Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395Ab3DIJVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:21:01 -0400
Received: from sauhun.de ([89.238.76.85]:56984 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965270Ab3DIJU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:20:58 -0400
Date: Tue, 9 Apr 2013 11:20:55 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [1/7] i2c-designware: move to managed functions (devm_*)
Message-ID: <20130409092055.GC3624@the-dreams.de>
References: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130409090032.GA28509@the-dreams.de>
 <20130409092212.GE21818@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409092212.GE21818@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > >  	i2c_dw_disable_int(dev);
> > > -	r = request_irq(dev->irq, i2c_dw_isr, IRQF_SHARED, pdev->name, dev);
> > > +	r = devm_request_irq(&pdev->dev, dev->irq, i2c_dw_isr, IRQF_SHARED,
> > > +			pdev->name, dev);
> > 
> > Is it ensured that no interrupts will happen during remove? Because the
> > adapter will be deleted before devm will free the interrupt.
> 
> Both platform and PCI driver disable the controller in their remove
> function, and interrupts will be disabled as well. Is this enough or should
> we handle this differently?

That's fine. Thanks!
