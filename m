Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaHSP6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:58:31 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:49144 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaHSP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:58:29 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 6/9] gpiolib: add API to get gpio desc and flags
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Darren Hart <dvhart@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1927766.GeLld99ozq@vostro.rjw.lan>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
	<20140817130004.4B9FDC4137F@trevor.secretlab.ca>
	<D016516D.A1AFA%dvhart@linux.intel.com>
	<1927766.GeLld99ozq@vostro.rjw.lan>
Date: Tue, 19 Aug 2014 10:58:27 -0500
Message-Id: <20140819155827.51AA2C40B51@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014 06:57:41 +0200, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> On Sunday, August 17, 2014 12:43:38 PM Darren Hart wrote:
> > On 8/17/14, 6:00, "Grant Likely" <grant.likely@secretlab.ca> wrote:
> > 
> > >>
> > >>+	/* Using device tree? */
> > >>+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > >>+		desc = of_find_gpio(dev, NULL, idx, flags);
> > >
> > >of_find_gpio() doesn't exist.
> > 
> > Hrm... As of 3.16.0 (e64df3ebe8262c8203d1fe4f541e0241c3112c01)
> > 
> > $ git blame -L1455,1456 drivers/gpio/gpiolib.c
> > bae48da2 (Alexandre Courbot 2013-10-17 10:21:38 -0700 1455) static struct
> > gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
> > 
> > Have we removed this in -next or something? (on the plane, will verify
> > upon landing)
> 
> In 3.17-rc1:
> 
> rafael@vostro:~/src/linux-pm> grep -r of_find_gpio *
> drivers/gpio/gpiolib.c:static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
> drivers/gpio/gpiolib.c:         desc = of_find_gpio(dev, con_id, idx, &lookupflags);

Weird, I don't know why I couldn't find it. I must have been on a
different branch. Sorry for the noise.

g.
