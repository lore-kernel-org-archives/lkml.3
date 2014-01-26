Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaAZT2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 14:28:17 -0500
Received: from mail.active-venture.com ([67.228.131.205]:51704 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAZT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 14:28:16 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E561D0.4040308@roeck-us.net>
Date: Sun, 26 Jan 2014 11:28:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LM Sensors <lm-sensors@lm-sensors.org>, Jean Delvare <khali@linux-fr.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: lm90 driver no longer working on PCs in 3.13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the lm90 driver is no longer working on PCs with the 3.13 kernel ... or at least not without
special configuration.

This is what I get if I try to instantiate a device on it (max6695):

i2c 1-0018: Driver lm90 requests probe deferral
i2c i2c-1: new_device: Instantiated device max6695 at 0x18

The regulator core always returns -EPROBE_DEFER if the platform does not support devicetree
and if the regulator it is looking for does not exist. Since the driver now requires a mandatory
regulator (commit 3e0f964f2ad - hwmon: (lm90) Add power control), and the regulator it requests
does not exist on a PC, the result is not really surprising. I thought the regulator core would
realize that it has to return a dummy regulator, but apparently that is not the case, or I don't
know how to configure it.

Any idea what I might need to do to get it working ?

Thanks,
Guenter
