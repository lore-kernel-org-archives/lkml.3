Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaKRQvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:51:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35889 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbaKRQvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:51:52 -0500
Date: Tue, 18 Nov 2014 17:51:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141118165148.GA11711@amd>
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com>
 <20141118084603.GC4059@amd>
 <546B19C8.2090008@samsung.com>
 <20141118113256.GA10022@amd>
 <546B40FA.2070409@samsung.com>
 <20141118132159.GA21089@amd>
 <546B6D86.8090701@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B6D86.8090701@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >If the hardware LED changes with one that needs different current, the
> >block for the adp1653 stays the same, but white LED block should be
> >updated with different value.
> 
> I think that you are talking about sub nodes. Indeed I am leaning
> towards this type of design.

I think I am :-).

> >>I agree that flash-timeout should be per led - an array, similarly
> >>as in case of iout's.
> >
> >Agreed about per-led, disagreed about the array. As all the fields
> >would need arrays, and as LED system currently does not use arrays for
> >label and linux,default-trigger, I believe we should follow existing
> >design and model it as three devices. (It _is_ physically three devices.)
> 
> Right, I missed that the leds/common.txt describes child node.
> 
> I propose following modifications to the binding:
> 
> Optional properties for child nodes:
> - iout-mode-led : 	maximum intensity in microamperes of the LED
> 		  	(torch LED for flash devices)
> - iout-mode-flash : 	initial intensity in microamperes of the
> 			flash LED; it is required to enable support
> 			for the flash led
> - iout-mode-indicator : initial intensity in microamperes of the
> 			indicator LED; it is required to enable support
> 			for the indicator led
> - max-iout-mode-led : 	maximum intensity in microamperes of the LED
> 		  	(torch LED for flash devices)
> - max-iout-mode-flash : maximum intensity in microamperes of the
> 			flash LED
> - max-iout-mode-indicator : maximum intensity in microamperes of the
> 			indicator LED
> - flash-timeout :	timeout in microseconds after which flash
> 			led is turned off

Ok, I took a look, and "iout" is notation I understand, but people may
have trouble with and I don't see it used anywhere else.

Also... do we need both "current" and "max-current" properties?

But regulators already have "regulator-max-microamp" property. So what
about:

max-microamp : 	maximum intensity in microamperes of the LED
 		  	(torch LED for flash devices)
max-flash-microamp : 	initial intensity in microamperes of the
 			flash LED; it is required to enable support
 			for the flash led
flash-timeout-microseconds : timeout in microseconds after which flash
 			led is turned off

If you had indicator on the same led, I guess

indicator-microamp : recommended intensity in microamperes of the LED
		         for indication

...would do?

> I propose to avoid name "torch", as for ordinary leds it would
> be misleading.

Agreed.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
