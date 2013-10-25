Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3JYWvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:51:39 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:63547 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3JYWvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:51:11 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv5 1/3] Input: twl4030-pwrbutton - add device tree support
To: Sebastian Reichel <sre@debian.org>, Rob Herring <robherring2@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20131023224940.GA19522@earth.universe>
References: <1382560002-6299-1-git-send-email-sre@debian.org> <1382560002-6299-2-git-send-email-sre@debian.org> <52684C8E.6080802@gmail.com> <20131023224940.GA19522@earth.universe>
Date: Fri, 25 Oct 2013 20:40:18 +0100
Message-Id: <20131025194018.71191C404D9@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct 2013 00:49:42 +0200, Sebastian Reichel <sre@debian.org> wrote:
> On Wed, Oct 23, 2013 at 05:24:14PM -0500, Rob Herring wrote:
> > So a twl4030 device is only a power button? DT should describe the h/w
> > not a node for a sub-function of a device.
> 
> No. TWL4030 is a companion chip for the OMAP3 processor. It provides
> miscellaneous functionality, e.g.:
> 
>  * RTC
>  * Watchdog
>  * Regulators
>  * Keypad Matrix
>  * USB
>  * Audio
>  * Vibrator
>  * GPIO
>  * ...
> 
> One part of the functionality is the power button. The patch
> assumes, that the twl4030-pwrbutton node is used as follows:
> 
> twl {
>     /* ... common stuff ... */
> 
>     pwrbutton {
>         compatible = "ti,twl4030-pwrbutton";
> 		interrupts = <8>;
>     };
> };
> 
> See also:
> * Documentation/devicetree/bindings/mfd/twl-familly.txt
> * Documentation/devicetree/bindings/watchdog/twl4030-wdt.txt
> * Documentation/devicetree/bindings/sound/omap-twl4030.txt
> * Documentation/devicetree/bindings/mfd/twl4030-power.txt
> * Documentation/devicetree/bindings/mfd/twl4030-audio.txt
> * Documentation/devicetree/bindings/gpio/gpio-twl4030.txt

Wow, that's crazy! It is all one device so put all the bindings into a
single file.

g,

