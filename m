Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3HURfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:35:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41882 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3HURff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:35:35 -0400
Message-ID: <5214FA64.3040902@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:35:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: balbi@ti.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        ian.campbell@citrix.com, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, bcousson@baylibre.com
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB
 ID detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com> <1376648029-30659-2-git-send-email-george.cherian@ti.com> <52127284.6030506@wwwdotorg.org> <521312CC.8060003@ti.com> <52139F0F.6090507@wwwdotorg.org> <5214BB6C.3060903@ti.com>
In-Reply-To: <5214BB6C.3060903@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 07:06 AM, George Cherian wrote:
> Hi Stephen,
> 
> On 8/20/2013 10:23 PM, Stephen Warren wrote:
>>> >ID pins are connected to pcf8575, and the pcf8575's interrupt line is
>>> >inturn connected to
>>> >gpio bank6 pin 11, we use this gpio interrupt to detect the ID pin
>>> change.
>> In that case, the PCF8575 node needs to be a GPIO controller and an IRQ
>> controller, as does the driver for the PCF8575. This binding should have
>> a single entry in the gpios property, and the driver can call
>> gpio_to_irq() on that so it knows which IRQ to request.
> 
> You meant some thing like this?
> 
>        pcf_usb: pcf8575@21 {
>                 compatible = "ti,pcf8575";
>                 reg = <0x21>;
>                 gpio-controller;
>                 #gpio-cells = <2>;
>                 interrupt-parent = <&gpio6>;
>                 interrupts = <11 2>;
>                 interrupt-controller;
>                 #interrupt-cells = <2>;
>      };
> 
>      usb_vid_gpio {
>                 compatible = "ti,dra7xx-usb";
>                 gpios = <&pcf_usb 1 0>;
>      };

Yes.

Except that the compatible value for the usb_vid_gpio node still looks
wrong, since I think that node isn't anything to do with any particular SoC.
