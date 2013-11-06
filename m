Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3KFUbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:31:23 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54037 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754985Ab3KFUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:31:22 -0500
Date: Wed, 6 Nov 2013 21:31:02 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Message-ID: <20131106203102.GB8662@breakpoint.cc>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <C10E33D7-53F6-4A50-9B84-1149DDBDC46F@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C10E33D7-53F6-4A50-9B84-1149DDBDC46F@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.11.13, Pantelis Antoniou wrote:
> Hi Sebastian,
Hi Pantelis,

> It has been discussed.
> 
> We are doing it because
> 
> a) We tried to do it in u-boot and it has been a complete disaster.
> Regular users just can't handle bootloader updates.

How so? The "additional" dtb piece was deleted by accident as part of
the u-boot upgrade? Do you maybe a link which describes the disaster?

> b) It is similar to that. It was originally created for the beaglebone,
> which has a concept of capes (similar to Arduino shields).
> http://circuitco.com/support/index.php?title=BeagleBone_Capes
> Turns out it's really useful to anyone doing reconfigurable hardware too,
> so that's why FPGA people are thinking of using it.

I am aware of this. My understanding is that those capes have hardware
information encoded in an eeprom behind i2c _and_ you can't or should
not replace capes at runtime.
Naive as I am I *assume* it should be easy to read this eeprom in u-boot
as part of the boot setup and extend the dtb before passing it to the
kernel. In case this works well, the problem here is a) ?

> c) There are people that want to tinker with Linux based hardware boards
> but are not kernel developers. This gives them a way to do so without
> having to recompile the kernel and/or reboot while tinkering.

I understand that they want to avoid reboot. But they still need to
recompile the device tree, don't they? Or does this allow to change the
HW description without knowing the syntax of .dts?

> Regards
> 
> -- Pantelis

Sebastian
