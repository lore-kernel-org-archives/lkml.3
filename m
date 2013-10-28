Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3J1Tav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:30:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47110 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3J1Tas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:30:48 -0400
Subject: Re: [PATCH 4/4] wl1251: spi: add device tree support
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CANOLnOP=antQDwQLxWhuB8+-kZh9x-JJXrXmOz3FH67fM2Lang@mail.gmail.com>
Date: Mon, 28 Oct 2013 14:30:45 -0500
Cc: Sebastian Reichel <sre@debian.org>, Mark Rutland <mark.rutland@arm.com>,
        linux-doc@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Rob Landley <rob@landley.net>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3381D0FB-2AAD-446D-8650-E4BE5F22A2E3@codeaurora.org>
References: <1382890469-25286-1-git-send-email-sre@debian.org> <1382890469-25286-5-git-send-email-sre@debian.org> <FF34C626-4A49-43B1-B0AD-DC6146ABBB11@codeaurora.org> <CANOLnOP=antQDwQLxWhuB8+-kZh9x-JJXrXmOz3FH67fM2Lang@mail.gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2013, at 12:15 PM, Grazvydas Ignotas wrote:

> On Mon, Oct 28, 2013 at 8:37 AM, Kumar Gala <galak@codeaurora.org> wrote:
>> On Oct 27, 2013, at 11:14 AM, Sebastian Reichel wrote:
>>> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
>>> @@ -0,0 +1,36 @@
>>> +* Texas Instruments wl1251 controller
>>> +
>>> +The wl1251 chip can be connected via SPI or via SDIO. The linux
>>> +kernel currently only supports device tree for the SPI variant.
>>> +
>> 
>> From the binding I have no idea what this chip actually does, also we don't normally reference linux kernel support in bindings specs (so please remove it).
>> 
>> However, what would expect the SDIO binding to look like?  Or more specifically, how would you distinguish the SPI vs SDIO binding/connection?  I'm wondering if the compatible should be something like "ti,wl1251-spi" and than the sdio can be "ti,wl1251-sdio"
> 
> When connected to SDIO, it doesn't act as standard SDIO device and
> can't be probed (standard SDIO registers missing), so information has
> to come some other way. That used to partially come through
> platform_data and partially through a callback from mmc subsystem (see
> pandora_wl1251_init_card() in
> arch/arm/mach-omap2/board-omap3pandora.c). I don't know much about DT,
> but maybe the information that comes from SDIO registers on "normal"
> SDIO devices should come through DT in this case too? I don't really
> know how that should be integrated with mmc subsystem though..

Ok, my point is still valid that we can use a different compatible for the SDIO case even if its no standard SDIO vs the SPI case.

> 
>>> +Required properties:
>>> +- compatible : Should be "ti,wl1251"
>> 
>> reg is not listed as a required prop.
>> 
>>> +- interrupts : Should contain interrupt line
>>> +- interrupt-parent : Should be the phandle for the interrupt
>>> +  controller that services interrupts for this device
>>> +- vio-supply : phandle to regulator providing VIO
>>> +- power-gpio : GPIO connected to chip's PMEN pin
>> 
>> should be vendor prefixed: ti,power-gpio
>> 
>>> +- For additional required properties on SPI, please consult
>>> +  Documentation/devicetree/bindings/spi/spi-bus.txt
>>> +
>>> +Optional properties:
>>> +- ti,use-eeprom : If found, configuration will be loaded from eeprom.
>> 
>> can you be a bit more specific on what cfg will be loaded.  Also, is this property a boolean, if so how do I know which eeprom the cfg is loaded from (is it one that is directly connected to the wl1251?
> 
> wl1251 is a wifi chip that can have an optional eeprom connected to it
> to store things like calibration stuff and MAC address, and that
> eeprom is usually inside a single module with some additional radio
> related chips. If the eeprom is connected (like the module on pandora
> board has), the driver can issue command to the firmware running on
> chip to load that data on it's startup, alternatively the driver can
> load calibration from other storage (like it happens on N900).

So sounds like a boolean.  I think just adding that its a boolean and maybe something like "configuration (calibration data, MAC addr, etc..)"

- k

> 
> 
> Gražvydas
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

