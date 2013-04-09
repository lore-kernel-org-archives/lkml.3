Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303Ab3DIJ3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:29:12 -0400
Received: from sauhun.de ([89.238.76.85]:48330 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936418Ab3DIJ27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:28:59 -0400
Date: Tue, 9 Apr 2013 11:28:57 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [5/7] i2c-designware: enable/disable the controller properly
Message-ID: <20130409092857.GE3624@the-dreams.de>
References: <1363867800-23861-5-git-send-email-mika.westerberg@linux.intel.com>
 <20130409090914.GD28509@the-dreams.de>
 <20130409092836.GG21818@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409092836.GG21818@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 12:28:36PM +0300, Mika Westerberg wrote:
> On Tue, Apr 09, 2013 at 11:09:14AM +0200, Wolfram Sang wrote:
> > 
> > > +static void __i2c_dw_enable(struct dw_i2c_dev *dev, bool enable)
> > > +{
> > > +	int timeout = 100;
> > > +
> > > +	do {
> > > +		dw_writel(dev, enable, DW_IC_ENABLE);
> > > +		if ((dw_readl(dev, DW_IC_ENABLE_STATUS) & 1) == enable)
> > > +			return;
> > > +
> > > +		usleep_range(25, 250);
> > 
> > This would wait 25ms max. Is there a timeout value specified in the docs?
> 
> The datasheet says something like:
> 
> 	1. Define a timer interval (t_i2c_poll) equal 10 times the highest
> 	signaling period. For 400kHz this is 25us.
> 
> 	2. Define max timeout parameter, MAX_T_POLL_COUNT, such that if any
> 	repeated operation exeeds this maximum, an error is reported.
> 
> In this case I have:
> 
> 	t_i2c_poll = 25 (to 250 us)
> 	MAX_T_POLL_COUNT = 100

Maybe worth a comment?

Other than that, the series looks fine to me.
