Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaHQXNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 19:13:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:45906 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaHQXNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 19:13:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="373527867"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Sun, 17 Aug 2014 12:43:38 -0500
Subject: Re: [RFC PATCH 6/9] gpiolib: add API to get gpio desc and flags
From: Darren Hart <dvhart@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        <linux-acpi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <D016516D.A1AFA%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH 6/9] gpiolib: add API to get gpio desc and flags
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-7-git-send-email-mika.westerberg@linux.intel.com>
 <20140817130004.4B9FDC4137F@trevor.secretlab.ca>
In-Reply-To: <20140817130004.4B9FDC4137F@trevor.secretlab.ca>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/14, 6:00, "Grant Likely" <grant.likely@secretlab.ca> wrote:

>>
>>+	/* Using device tree? */
>>+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
>>+		desc = of_find_gpio(dev, NULL, idx, flags);
>
>of_find_gpio() doesn't exist.

Hrm... As of 3.16.0 (e64df3ebe8262c8203d1fe4f541e0241c3112c01)

$ git blame -L1455,1456 drivers/gpio/gpiolib.c
bae48da2 (Alexandre Courbot 2013-10-17 10:21:38 -0700 1455) static struct
gpio_desc *of_find_gpio(struct device *dev, const char *con_id,

Have we removed this in -next or something? (on the plane, will verify
upon landing)



-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



