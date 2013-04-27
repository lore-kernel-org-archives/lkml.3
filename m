Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3D0Ixj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 04:53:39 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:48258 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3D0Ixh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 04:53:37 -0400
Date: Sat, 27 Apr 2013 10:53:06 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DavidLv@viatech.com.cn, ShirleyHu@viatech.com.cn,
        AndersMa@viatech.com.cn
Subject: Re: VIA velocity network driver
Message-ID: <20130427085306.GA24622@electric-eye.fr.zoreil.com>
References: <517B6267.4070404@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517B6267.4070404@prisktech.co.nz>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Prisk <linux@prisktech.co.nz> :
> I would like to add support to this driver for platform devices as
> found on VIA's APC8750 board. At the moment, I have a standalone
> platform version that works fine, but wanted to ask a few questions
> before sending a patch to merge this code into one driver.
> 
> The current driver is for PCI network cards, and uses pci dma
> functions. Most of the pci dma functions are wrappers around other
> functions which is what I have used for the platform version.

[...]
> Is it ok to use the non-pci versions (which are basically just the
> unwrapped pci versions) and pass the struct device *, or will I need
> to use the correct function for the correct instance.

It's ok.

A standalone patch to convert the pci dma functions and check the
returned status code of the new one would be welcome regardless of
any future change in the driver data struct.

[...]
> I assume this is loading something from an EEPROM, but there is no
> EEPROM on the APC8750. Removing this code, the driver seems to work
> fine on the APC8750.

I feel a "no documentation" disturbance in the force.

Via's people Cced.

> Could it be avoided with a vptr->has_no_eeprom that defaults to 0 to
> avoid breaking existing support?

Yes. No unnecessary module option please.

-- 
Ueimor
