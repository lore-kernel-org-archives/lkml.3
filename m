Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaAZUON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:14:13 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:40856 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaAZUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:14:12 -0500
Date: Sun, 26 Jan 2014 21:13:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Subject: Re: lm90 driver no longer working on PCs in 3.13
Message-ID: <20140126211357.6fa68909@endymion.delvare>
In-Reply-To: <52E561D0.4040308@roeck-us.net>
References: <52E561D0.4040308@roeck-us.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Adding Wei Ni to Cc, as he provided the commit which causes problem.

On Sun, 26 Jan 2014 11:28:16 -0800, Guenter Roeck wrote:
> Hi,
> 
> the lm90 driver is no longer working on PCs with the 3.13 kernel ... or at least not without
> special configuration.
> 
> This is what I get if I try to instantiate a device on it (max6695):
> 
> i2c 1-0018: Driver lm90 requests probe deferral
> i2c i2c-1: new_device: Instantiated device max6695 at 0x18
> 
> The regulator core always returns -EPROBE_DEFER if the platform does not support devicetree
> and if the regulator it is looking for does not exist. Since the driver now requires a mandatory
> regulator (commit 3e0f964f2ad - hwmon: (lm90) Add power control), and the regulator it requests
> does not exist on a PC, the result is not really surprising. I thought the regulator core would
> realize that it has to return a dummy regulator, but apparently that is not the case, or I don't
> know how to configure it.
> 
> Any idea what I might need to do to get it working ?

Me, I really don't know. I seem to remember I tested Wei's patch set on
an emulated ADM1032 chip and it was working fine. So maybe it depends
on the kernel configuration, or something changed on the regulator side
meanwhile.

-- 
Jean Delvare
