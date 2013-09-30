Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3I3R32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:29:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:19018 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab3I3R31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:29:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="411945653"
Message-ID: <1380562166.32071.172.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: GPIO: Performance sensitive applications, gpiochip-level locking
From: Darren Hart <dvhart@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 30 Sep 2013 10:29:26 -0700
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently working with a graphics driver that makes use of 2 GPIO
pins for EDID communication (clock and data). In order to coexist
peacefully with the driver for the GPIO chip, it must use gpiolib to
request the lines, set direction, and set values. This results in a
spinlock/unlock for every operation with this particular gpio driver.

It would be preferable to lock the resources once, perform the EDID
communication, then unlock the resources. The resources in this case are
the value and direction registers off the PCI GPIO base address register
which is shared with the other lines provided by the GPIO chip.

Is there a best practice for dealing with this kind of configuration?

If not, would it make sense to add optional gpiochip-level lock/unlock
and lockless direction and value operations to the gpiochip function
block?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


