Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaKRIqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:46:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44037 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaKRIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:46:07 -0500
Date: Tue, 18 Nov 2014 09:46:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141118084603.GC4059@amd>
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546AFEA5.9020000@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-18 09:09:09, Jacek Anaszewski wrote:
> Hi Pavel, Sakari,
> 
> On 11/17/2014 03:58 PM, Sakari Ailus wrote:
> >Hi Pavel,
> >
> >On Sun, Nov 16, 2014 at 08:59:28AM +0100, Pavel Machek wrote:
> >>For device tree people: Yes, I know I'll have to create file in
> >>documentation, but does the binding below look acceptable?
> >>
> >>I'll clean up driver code a bit more, remove the printks. Anything
> >>else obviously wrong?
> >
> >Jacek Anaszewski is working on flash support for LED devices. I think it'd
> >be good to sync the DT bindings for the two, as the types of devices
> >supported by the LED API and the V4L2 flash API are quite similar.
> >
> >Cc Jacek.
> 
> I've already submitted a patch [1] that updates leds common bindings.
> I hasn't been merged yet, as the related LED Flash class patch [2]
> still needs some indicator leds related discussion [3].
> 
> I think this is a good moment to discuss the flash related led common
> bindings.

Part of problem is that adp1653 is not regarded as "LED" device by
current kernel driver.

> [1] http://www.spinics.net/lists/linux-leds/msg02121.html

@@ -3,6 +3,17 @@ Common leds properties.
 Optional properties for child nodes:
 - label : The label for this LED.  If omitted, the label is
   taken from the node name (excluding the unit address).
+- iout-torch : Array of maximum intensities in microamperes of the
 torch
+	led currents in order from sub-led 0 to N-1, where N is the
 number
+	of torch sub-leds exposed by the device
+- iout-flash : Array of maximum intensities in microamperes of the
 flash
+	led currents in order from sub-led 0 to N-1, where N is the
 number
+	of flash sub-leds exposed by the device
+- iout-indicator : Array of maximum intensities in microamperes of
+  the indicator led currents in order from sub-led 0 to N-1,
+  where N is the number of indicator sub-leds exposed by the device
+- flash-timeout : timeout in microseconds after which flash led
+  is turned off
 
 - linux,default-trigger :  This parameter, if present, is a
     string defining the trigger assigned to the LED.  Current
     triggers are:
@@ -19,5 +30,10 @@ Examples:
 system-status {
 	       label = "Status";
 	       linux,default-trigger = "heartbeat";
+	       iout-torch = <500 500>;
+	       iout-flash = <1000 1000>;
+	       iout-indicator = <100 100>;
+	       flash-timeout = <1000>;
+
	...
 };

I don't get it; system-status describes single LED, why are iout-torch
(and friends) arrays of two?

Also, at least on adp1653, these are actually two leds -- white and
red. Torch and flash is white led, indicator is red led.

> [2] http://www.spinics.net/lists/linux-media/msg83100.html
> [3] http://www.spinics.net/lists/linux-leds/msg02472.html

What device are you using for testing? Can you cc me on future
patches?

Why do we need complex "flash LED class" support, and where is the
V4L2 glue?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
