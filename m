Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJPSfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 14:35:10 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51915 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaJPSfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 14:35:08 -0400
Date: Thu, 16 Oct 2014 11:35:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull@opensource.altera.com
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v6 3/4] pmbus: add regulator support
Message-ID: <20141016183501.GA21253@roeck-us.net>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
 <1413399310-19277-4-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413399310-19277-4-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 01:55:09PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add support for simple on/off control of each channel.
> 
> To add regulator support, the pmbus part driver needs to add
> regulator_desc information and number of regulators to its
> pmbus_driver_info struct.
> 
> regulator_desc can be declared using default macro for a
> regulator (PMBUS_REGULATOR) that is in pmbus.h
> 
> The regulator_init_data can be initialized from either
> platform data or the device tree.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Cc: Guenter Roeck <linux@roeck-us.net>

Hi Alan,

I am still seeing lots of the following:

vout0: Failed to create debugfs directory
vout1: Failed to create debugfs directory
vout2: Failed to create debugfs directory
vout3: Failed to create debugfs directory
vout4: Failed to create debugfs directory
vout5: Failed to create debugfs directory
vout6: Failed to create debugfs directory
vout7: Failed to create debugfs directory

I thought there was a problem in the regulator core, but after looking
into it concluded that the regulator core _should_ prepend the names
with the device name when creating the debugfs entries, unless no device
name is specified. So something must be missing. We'll need to sort
this out before I can accept the code.

Thanks,
Guenter
