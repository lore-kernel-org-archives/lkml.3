Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbbAJSlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:41:50 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46794 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbbAJSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:41:49 -0500
Date: Sat, 10 Jan 2015 19:41:46 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 3/8] watchdog: at91rm9200: use the regmap from mfd
Message-ID: <20150110184146.GH2447@piout.net>
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1420797094-9444-4-git-send-email-alexandre.belloni@free-electrons.com>
 <54B074B9.2090704@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B074B9.2090704@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2015 at 16:39:21 -0800, Guenter Roeck wrote :
> On 01/09/2015 01:51 AM, Alexandre Belloni wrote:
> >  /* ......................................................................... */
> >@@ -204,6 +201,7 @@ static struct miscdevice at91wdt_miscdev = {
> >  static int at91wdt_probe(struct platform_device *pdev)
> >  {
> >  	int res;
> >+	regmap_st = dev_get_drvdata(pdev->dev.parent);
> >
> 
> Is it guaranteed that parent is never NULL, and that the parent's
> drvdata is always set ?
> 

The only way to probe the driver left is to use platform_data. It is
done from the MFD driver. If you prefer, I can test for NULL here and
return.

> Also, it seems that regmap_st will be overwritten if the device
> is already open (see code below). That may not be a good idea.
> 

I'm not sure what you meani, pdev->dev.parent and at91wdt_miscdev.parent
are not the same thing. I didn't touch the code below but I believe
there is no reason to pass in the probe twice and return -EBUSY.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
