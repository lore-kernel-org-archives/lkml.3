Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3GJKqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:46:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:40663 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab3GJKqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="367725973"
Date: Wed, 10 Jul 2013 13:52:15 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130710105215.GY4898@intel.com>
References: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130708134216.GB6402@ab42.lan>
 <20130709084402.GF4898@intel.com>
 <20130709161927.GC30236@ab42.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709161927.GC30236@ab42.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:19:28PM +0200, Christian Ruppert wrote:
> What I meant is the following: The clock cycle time Tc is composed of
> the four components
> 
>   Tc = Th + Tf + Tl + Tr
> 
> where
>   Th: Time during which the signal is high
>   Tf: Falling edge transition time
>   Tl: Time during which the signal is low
>   Tr: Rising edge transition time
> 
> The I2C specification specifies a minimum for Tl and Th and a range (or
> maximum) for Tr and Tf. A maximum frequency is specified as the
> frequency obtained by adding the minima for Th and Tl to the maxima of
> Tr ant Tf.
> Since as you said, transition times are very much PCB dependent, one way
> to guarantee the max. frequency constraint (and to achieve a constant
> frequency at its max) is to define the constants
> Th' = Th + Tf := Th_min + Tf_max
> Tl' = Tl + Tr := Tl_min + Tr_max
> 
> and to calculate the variables
> Th = Th' - Tf
> Tl = Tl' - Tr
> in function of Tf and Tr of the given PCB.

If I understand the above, it leaves Tf and Tr to be PCB specific and then
these values are passed to the core driver from platform data, right?

I'm thinking that passing directly the "measured" *CNT values from the
platform data makes this even more accurate (given that information is
available). And if you only have the Tf and Tr for your board, you can have
custom calculation done in the platform part of the driver that takes them
into account, and then passes these custom *CNT values to the core.

> > At least on Intel
> > hardware we have an ACPI method that returns directly the optimum *CNT
> > values.
> 
> I don't know ACPI very well and if it deals with register values
> directly your patch is probably the right thing.

Our FW people decided to have a custom ACPI method that returns the correct
values to be used in the Windows I2C driver. It returns direct *CNT
register values that have been measured to be good for a given PCB.

> The timing calculation in the driver seems a bit strange to me, however
> (see above), but I never dared touching it because I never had time to
> dive into the code deep enough and I was just wondering if it was
> possible to fix it at the same time.

It would be good if we can fix this for non-ACPI devices as well. Is it
hard to add similar properties to the driver specific Device Tree bindings?

Wolfram, do you have any input on this?
