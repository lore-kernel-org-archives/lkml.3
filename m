Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3GTTAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 15:00:14 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49581 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3GTTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 15:00:12 -0400
X-Auth-Info: qkJXN8W34Aegi1TLeGB/pWmzCtt8A1AFt/b+iTxLevw=
From: Marek Vasut <marex@denx.de>
To: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v2 5/5] iio: mxs-lradc: add write_raw function to modify scale
Date: Sat, 20 Jul 2013 21:00:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: Hector Palacios <hector.palacios@digi.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <51E967D8.8020001@digi.com> <51E9A029.3000008@kernel.org>
In-Reply-To: <51E9A029.3000008@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307202100.09749.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jonathan Cameron,

> On 07/19/2013 05:22 PM, Hector Palacios wrote:
> > Dear Marek,
> > 
> > On 07/19/2013 06:17 PM, Marek Vasut wrote:
> >>> Here you have three entries per channel:
> >>> in_voltageX_raw        -> the sample raw value
> >>> in_voltageX_scale    -> the scale to multiply the raw value to get the
> >> 
> >> voltage
> >> 
> >>> in mV in_voltageX_scale_available -> lists the available scales of the
> >>> channel
> >>> 
> >>> For example for channel 0:
> >>> 
> >>> # cat in_voltage0_scale_available
> >>> 0.451660156 0.903320312    (two scales available, first with divider by
> >>> two disabled, second with divider by two enabled)
> >>> 
> >>> # cat in_voltage0_scale
> >>> 0.451660156            (divider by two is currently disabled)
> >>> 
> >>> # cat in_voltage0_raw        (shows measured value)
> >>> 1000
> >>> 
> >>> If you multiply the value by the scale you get: 1000 * 0.451660156 =
> >>> 451.6 mV
> >>> 
> >>> # echo 0.903320312 > in_voltage0_scale    (enables the divider by two)
> >> 
> >> Ok, so I have to remember this value : '0.903320312' in case I want to
> >> enable divide-by-two functionality?
> > 
> > No you don't. That's why there is a 'in_voltage_scale_available' that
> > lists the available values.
> > 
> >> Hmmmm ... why would this interface not work:
> >> echo 2 > in_voltage0_scale
> >> 
> >> or
> >> 
> >> echo 1 > in_voltage0_scale
> > 
> > An easy thing like that is what I first submitted, but it was rejected
> > and I was told to use the scale_available descriptor instead, which is
> > the common interface the rest of drivers use.
> 
> This comes down to allowing us to have one generic predictable interface
> (which sometimes ends up looking uggly!).  The key thing is that if you
> are outputing using the _raw sysfs interfaces, the aim is to avoid doing
> nasty maths in kernel to get to 'standard' units such as mV.

OK, understood.

> Hence that scale attribute tells you what to apply to the value.  If you
> just wanted it to be 1 or 2 then the in_voltage0_raw value would have to
> be a long and nasty decimal.  Now we do have the option of
> in_voltage0_calibscale which would be applied internally to the value but
> it really isn't for this purpose (it's for devices with a 'trim' control)
> and you'd still have scale set to 0.903320312 or similar. Although they
> have meaning obviously, in this case 1 and 2 are little more than 'magic'
> numbers.
> 
> Note that when things are quite, I'm at least in theory working on a
> cleaner interface for these 'available' attributes that would also provide
> in kernel access for IIO consumers. Basically this will be another
> callback to get either the 'range' of pseudo continuous variables or the
> 'available' set for parameters like this.

Thanks for the explanation!

> Being lazy I'm happy to let someone else clean this corner up if they like?
> *looks hopeful*

Please don't look at me, I already am fully loaded with fixing my mess all 
around ;-/

Best regards,
Marek Vasut
