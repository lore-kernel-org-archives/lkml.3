Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaDWWyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:54:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57468 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaDWWyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:54:13 -0400
Message-ID: <53584491.6000604@codeaurora.org>
Date: Wed, 23 Apr 2014 17:54:09 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Westerberg, Mika" <mika.westerberg@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>	<CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>	<534B93BA.6020406@linux.intel.com>	<534BFAAF.3070805@codeaurora.org>	<534D0370.50108@linux.intel.com>	<535005BA.1040405@codeaurora.org>	<5357A80B.8030701@linux.intel.com>	<5357ACF1.9070206@codeaurora.org>	<20140423135915.GY30677@intel.com>	<5357D8CC.3080501@codeaurora.org> <CACRpkdbk8okbzaZgD=BqeMSOvbEvYNViqamd9i=NAaAWW=T9sQ@mail.gmail.com>
In-Reply-To: <CACRpkdbk8okbzaZgD=BqeMSOvbEvYNViqamd9i=NAaAWW=T9sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
>> >  All of our GPIOs have a
>> >pinmux on them, and so if you want to use the pin for the non-default
>> >functionality, you need to configure the mux.  Isn't that supposed to happen
>> >with the through the pinctrl driver?  That is, when the kernel parses the
>> >ASL, and it seems a command to configure pin #3 to function #4, it calls the
>> >local pinctrl driver to do that?
> Let's suspect this is true. That is how GPIO work after all is it not?

With device trees, function groups are defined by name in the driver, 
and the device tree contains these same names as links between nodes. 
This works well.

In ACPI, it appears that no such infrastructure exists.

> I guess the other option would be that all systems must come with a
> tailored set-up written in ASL, specific for each board configuration.

That makes sense (U-Boot does fixups of the device tree based on actual 
board config, so it's conceivable that UEFI could do the same for ASL). 
  However, that would require either

1) UEFI programs the GPIO muxes directly, without specifying any mux 
information in ASL and without using the Linux driver to program the muxes.

or

2) ASL contains code to program the muxes, and Linux parses that ASL and 
calls the pinctrl driver to program the hardware.

I don't know which direction the Community wants to use.  If we go with 
option #1, then there is no need for the pinctrl driver to specify 
function groups at all.  This means we would not need a separate pinctrl 
driver for each SOC, like we do today.


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
