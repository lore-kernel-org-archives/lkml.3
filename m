Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaKSPCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:02:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKSPCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:02:05 -0500
Message-ID: <546CB0EB.9080005@suse.de>
Date: Wed, 19 Nov 2014 16:02:03 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mason <mpeg.blue@free.fr>
CC: LKML <linux-kernel@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Looking for good references for ARM driver development
References: <546C920A.7060800@free.fr>
In-Reply-To: <546C920A.7060800@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 19.11.2014 um 13:50 schrieb Mason:
> [...] I'm writing a driver for a temperature sensor, which is
> supposed to work
> within the hwmon/lm-sensors framework.
> 
> The sensor's API consists of 3 memory-mapped registers, which are
> accessible over the
> SoC's memory bus. [...]
> 
> 1) Which bus should I be using for this driver? Is the platform bus
> appropriate?

Probably.

> 2) platform.txt states
> 
>> Some drivers are not fully converted to the driver model, because they
>> take
>> on a non-driver role:  the driver registers its platform device,
>> rather than
>> leaving that for system infrastructure.  Such drivers can't be hotplugged
>> or coldplugged, since those mechanisms require device creation to be in a
>> different system component than the driver.
> 
> How do I "leave device registration for the system infrastructure"?
> Where should I put that code?
> Is it a good idea to separate device registration and driver registration
> in the case of a SoC, where the device is embedded in the SoC and is not
> "hot-plugged" (or anything-plugged for that matter, it's just "there").

Since this appears to be about an ARM SoC according to your To list, in
general, you create a device tree binding, that binding is registered
within your platform/... driver code and referenced in the device tree
for SoC or board, and then your driver will automatically be probed.

> 4) Can I use platform_driver_probe, instead of platform_driver_register?

Most likely you do not need to call either yourself.

Just compare other platform drivers on the one hand, and temparature
sensor drivers on the other (such as I2C based gmt,g781 / LM90).
Did you already check whether there is a driver that is both?

Regards,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
