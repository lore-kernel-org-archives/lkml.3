Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3HAK4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:56:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3338 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3HAK4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:56:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Aug 2013 03:55:18 -0700
Message-ID: <1375355332.32701.13.camel@bilhuang-vm1>
Subject: Re: [PATCH v2 1/1] mfd: palmas: Add power off control
From: Bill Huang <bilhuang@nvidia.com>
To: Nishanth Menon <nm@ti.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Date: Thu, 1 Aug 2013 04:08:52 -0700
In-Reply-To: <51F8FBC4.1040009@ti.com>
References: <1375255037-10024-1-git-send-email-bilhuang@nvidia.com>
	 <51F8FBC4.1040009@ti.com>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 19:57 +0800, Nishanth Menon wrote:
> 
> If you notice the reference code I send, atleast on TWL6035/37 variants 
> of Palmas, USB IRQ unmask is mandatory for power on with USB cable - 
> example usage scenario: extremely low battery, device powered off, plug 
> in usb cable to restart charging - you'd like to initiate charging logic 
> in bootloader, but that wont work if the device does not do OFF-ON 
> transition with usb cable plugged in for vbus.
> 
Why do we need to add Palmas USB_IRQ unmask logic in shutdown? Does that
mean for all platform using Palmas has to unmask USB IRQ (including
those do not power vbus through Palmas)? Can't we just have a simple
shutdown function but have the VBus programming been done in USB driver
or maybe platform driver since it is platform specific control?

