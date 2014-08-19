Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaHSPWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:22:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:61316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaHSPWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="590253512"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Tue, 19 Aug 2014 10:21:34 -0500
Subject: Re: [RFC PATCH 8/9] Input: gpio_keys_polled - Make use of device
 property API
From: Darren Hart <dvhart@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: "Rafael J. Wysocki" <rafael@kernel.org>, Al Stone <al.stone@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Triplett <josh@joshtriplett.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
        Robert Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Mark Brown <broonie@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-acpi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <D018D57F.A1FED%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH 8/9] Input: gpio_keys_polled - Make use of device
 property API
References: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408172039-32513-9-git-send-email-mika.westerberg@linux.intel.com>
 <20140818105512.7889980b@ultegra>
 <20140819092753.GI1660@lahna.fi.intel.com>
In-Reply-To: <20140819092753.GI1660@lahna.fi.intel.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/14, 4:27, "Mika Westerberg" <mika.westerberg@linux.intel.com>
wrote:

>On Mon, Aug 18, 2014 at 10:55:12AM -0700, Jacob Pan wrote:
>> On Sat, 16 Aug 2014 09:53:58 +0300
>> Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
>> 
>> > From: Aaron Lu <aaron.lu@intel.com>
>> > 
>> > Make use of device property API in this driver so that both OF based
>> > system and ACPI based system can use this driver.
>> > 
>> Do we always assume OF and ACPI _DSD will have the same property name
>> strings? i.e. in this patch "gpios"
>> > +	if (device_property_get(dev, "gpios", NULL)) {
>> > -		if (!of_find_property(pp, "gpios", NULL)) {
>> 
>> Maybe i missed something, but I don't think we can make that assumption
>> in BIOS. If not, what is the point of having unified interface?
>
>We recommend that when it makes sense, the property names in _DSD follow
>the corresponding DT names.
>

This is especially try for platform drivers such as this.

We will be creating subsystem types, "gpios", and defining them in the
_DSD Implementors Guide (per our discussion this morning at Kernel Summit).
-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



