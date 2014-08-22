Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbaHVOi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:38:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45578 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbaHVOi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:38:56 -0400
Date: Fri, 22 Aug 2014 16:38:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Trickle charging for rtc-bq32k
Message-ID: <20140822143853.GA28820@amd>
References: <20140822131150.GA26724@amd>
 <20140822142852.GA1545@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822142852.GA1545@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-08-22 09:28:52, Wolfram Sang wrote:
> 
> > _But_ this should probably be enabled using device tree entry, right?
> > Unfortunately, the driver is i2c driver, not platform one, so I don't
> > see how to do that easily...
> 
> Trickle charging is usually depending on the hardware setup, so
> devicetree is actually a good place to put it. We'd just need generic
> bindings so that they could be applied to various RTC. Just guessing,
> resistor value would probably be one such property? We would not need
> putting plain register values into DT.

Well, for bq32000 there's selection between "no charging", "diode +
resistor", "different resistor".

> There should be no difference regarding DT between i2c and platform
> drivers.

Do you have example how to acces of_ from i2c driver?

Platform drivers do:

static int palmas_rtc_probe(struct platform_device *pdev)
{
        struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
        struct palmas_rtc *palmas_rtc = NULL;
	int ret;
        bool enable_bb_charging = false;
        bool high_bb_charging;

        if (pdev->dev.of_node) {
	   enable_bb_charging =
	   of_property_read_bool(pdev->dev.of_node,
                                        "ti,backup-battery-chargeable");
					        high_bb_charging =
	   of_property_read_bool(pdev->dev.of_node,
                                        "ti,backup-battery-charge-high-current");

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
