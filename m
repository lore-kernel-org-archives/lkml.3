Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaHREiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 00:38:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54279 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750762AbaHREit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 00:38:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/9] gpiolib: add API to get gpio desc and flags
Date: Mon, 18 Aug 2014 06:57:41 +0200
Message-ID: <1927766.GeLld99ozq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <D016516D.A1AFA%dvhart@linux.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com> <20140817130004.4B9FDC4137F@trevor.secretlab.ca> <D016516D.A1AFA%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 17, 2014 12:43:38 PM Darren Hart wrote:
> On 8/17/14, 6:00, "Grant Likely" <grant.likely@secretlab.ca> wrote:
> 
> >>
> >>+	/* Using device tree? */
> >>+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> >>+		desc = of_find_gpio(dev, NULL, idx, flags);
> >
> >of_find_gpio() doesn't exist.
> 
> Hrm... As of 3.16.0 (e64df3ebe8262c8203d1fe4f541e0241c3112c01)
> 
> $ git blame -L1455,1456 drivers/gpio/gpiolib.c
> bae48da2 (Alexandre Courbot 2013-10-17 10:21:38 -0700 1455) static struct
> gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
> 
> Have we removed this in -next or something? (on the plane, will verify
> upon landing)

In 3.17-rc1:

rafael@vostro:~/src/linux-pm> grep -r of_find_gpio *
drivers/gpio/gpiolib.c:static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
drivers/gpio/gpiolib.c:         desc = of_find_gpio(dev, con_id, idx, &lookupflags);

Rafael

