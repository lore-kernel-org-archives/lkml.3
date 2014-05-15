Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaEOU3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:29:24 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46389 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOU3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:29:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "Mark A. Greer" <mgreer@animalcreek.com>
Subject: bq24190: What's the correct API to turn boost mode (OTG) on for the battery charger ?
Date: Thu, 15 May 2014 22:29:26 +0200
Message-ID: <2044381.o3QyvTfyIx@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to enable battery charging on an OMAP4 board based on a twl6030 
PMIC with external bq24190 battery charger and bq27510 fuel gauge.

The system has an OTG USB port that can be used to charge the battery, and 
that can also be used in host mode. In that case the bq24190 needs to be 
switched to boost mode to provide the +5V power supply from the battery.

The bq24190 has a charge configuration register field that supports charge 
disabled, charge enabled and OTG (boost mode). The field is set by the bq24190 
driver in response to setting the charge type : POWER_SUPPLY_CHARGE_TYPE_NONE 
will disable charing, and POWER_SUPPLY_CHARGE_TYPE_TRICKLE and 
POWER_SUPPLY_CHARGE_TYPE_FAST will enable it. However, OTG boost mode is not 
supported.

The driver exposes most register fields as sysfs attributes (which doesn't 
sound very safe to me, but that's another story). I can thus enable OTG boost 
mode directly from userspace through the driver-specific API, but that just 
bypasses the power supply API. I'm thus not very fond of that solution.

Possibly due to my really basic (not to say nonexistent) knowledge of the 
power supply subsystem I haven't found an API to expose this feature. I was 
wondering if someone had given a though regarding how to implement this 
properly.

-- 
Regards,

Laurent Pinchart

