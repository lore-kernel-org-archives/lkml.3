Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3DVH6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:58:10 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43878 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3DVH6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:58:06 -0400
Message-ID: <5174ED8A.5090802@free-electrons.com>
Date: Mon, 22 Apr 2013 09:58:02 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, jimwall@q.com,
        brian@crystalfontz.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/3] iio: Add Nuvoton NAU7802 ADC driver
References: <1366299536-18353-1-git-send-email-alexandre.belloni@free-electrons.com> <1366299536-18353-2-git-send-email-alexandre.belloni@free-electrons.com> <51726541.6060304@kernel.org> <5172B68B.4010506@free-electrons.com>
In-Reply-To: <5172B68B.4010506@free-electrons.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre, Jonathan,

Le 20/04/2013 17:38, Alexandre Belloni a écrit :
> On 20/04/2013 11:52, Jonathan Cameron wrote:
>>> +	&iio_dev_attr_gain.dev_attr.attr,
>>> +	&iio_const_attr_gain_available.dev_attr.attr,
>>> +	&iio_dev_attr_min_conversions.dev_attr.attr,
>> What governs this?  Looks to me more like it should be hidden away
>> in the device tree than be here.
> 
> I guess it will depend on what you connect to your adc. Do we want to
> fix that in the DT or to be able to change it at runtime ?

I don't think so. Unless I misunderstood it, this attribute is the
number of conversions that must occur when switching from one channel to
another to get a good-enough precision for the ADC, right?

So I don't really see 1) why it could be changed by the user through
sysfs in the first place 2) this is not hardware configuration at all,
more some black magic within the driver, so it shouldn't be at all in
the device tree anyway.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
