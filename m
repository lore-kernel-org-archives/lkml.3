Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbbATPiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:38:25 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:57764 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbATPiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:38:23 -0500
Date: Tue, 20 Jan 2015 15:38:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH/RFC v10 09/19] DT: Add documentation for the mfd Maxim
 max77693
Message-ID: <20150120153815.GB13701@x1>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-10-git-send-email-j.anaszewski@samsung.com>
 <20150120112107.GG13701@x1>
 <54BE67EA.2070507@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE67EA.2070507@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Jacek Anaszewski wrote:

> On 01/20/2015 12:21 PM, Lee Jones wrote:
> >On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
> >
> >>This patch adds device tree binding documentation for
> >>the flash cell of the Maxim max77693 multifunctional device.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Lee Jones <lee.jones@linaro.org>
> >>Cc: Chanwoo Choi <cw00.choi@samsung.com>
> >>Cc: Bryan Wu <cooloney@gmail.com>
> >>Cc: Richard Purdie <rpurdie@rpsys.net>
> >>Cc: Rob Herring <robh+dt@kernel.org>
> >>Cc: Pawel Moll <pawel.moll@arm.com>
> >>Cc: Mark Rutland <mark.rutland@arm.com>
> >>Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> >>Cc: Kumar Gala <galak@codeaurora.org>
> >>---
> >>  Documentation/devicetree/bindings/mfd/max77693.txt |   69 ++++++++++++++++++++
> >>  1 file changed, 69 insertions(+)
> >>
> >>diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
> >>index 01e9f30..ef184f0 100644
> >>--- a/Documentation/devicetree/bindings/mfd/max77693.txt
> >>+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
> >>@@ -41,7 +41,52 @@ Optional properties:
> >>  	 To get more informations, please refer to documentaion.
> >>  	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
> >>
> >>+- led : the LED submodule device node
> >>+
> >>+There are two led outputs available - fled1 and fled2. Each of them can
> >>+control a separate led or they can be connected together to double
> >>+the maximum current for a single connected led. One led is represented
> >>+by one child node.
> >>+
> >>+Required properties:
> >>+- compatible : Must be "maxim,max77693-led".
> >>+
> >>+Optional properties:
> >>+- maxim,trigger-type : Flash trigger type.
> >>+	Possible trigger types:
> >>+		MAX77693_LED_TRIG_TYPE_EDGE - Rising edge of the signal triggers
> >>+			the flash,
> >>+		MAX77693_LED_TRIG_TYPE_LEVEL - Strobe pulse length controls
> >>+			duration of the flash.
> >
> >I think you should represent the proper values here instead of the
> >defines.
> 
> I see both versions in the existing bindings and also a combination of
> them, e.g.: MAX77693_LED_TRIG_TYPE_EDGE (0). I think that it is
> reasonable to mention the macros, especially if they are to appear
> in the DT binding example at the end of the documentation file.
> 
> >>+- maxim,boost-mode :
> >>+	In boost mode the device can produce up to 1.2A of total current
> >>+	on both outputs. The maximum current on each output is reduced
> >>+	to 625mA then. If not enabled explicitly, boost setting defaults to
> >>+	MAX77693_LED_BOOST_FIXED in case both current sources are used.
> >>+	Possible values:
> >>+		MAX77693_LED_BOOST_OFF - no boost,
> >>+		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
> >>+		MAX77693_LED_BOOST_FIXED - fixed mode.
> >
> >Same here.
> 
> MAX77693_LED_BOOST_OFF (0) - no boost,
> MAX77693_LED_BOOST_ADAPTIVE (1) - adaptive mode,
> MAX77693_LED_BOOST_FIXED (2) - fixed mode.

This is fine too.

> >>+- maxim,boost-vout : Output voltage of the boost module in millivolts.
> >
> >-mvout?
> >-microvout?
> 
> maxim,boost-mvout ?

Right.

> >>+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
> >>+	if chip estimates that system voltage could drop below this level due
> >>+	to flash power consumption.
> >
> >mvsys?
> >microvsys?
> 
> maxim,mvsys-min ?

Looks okay to me.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
