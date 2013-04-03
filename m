Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968Ab3DCNrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:47:46 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:37775 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476Ab3DCNrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:47:45 -0400
Date: Wed, 3 Apr 2013 15:46:43 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Johan Hovold <jhovold@gmail.com>, linux-arm-kernel@lists.infradead.org,
        dgilbert@interlog.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] rtc: rtc-at91rm9200: manage IMR depending on
 revision
Message-ID: <20130403134643.GD27600@localhost>
References: <1364908007-5150-1-git-send-email-nicolas.ferre@atmel.com>
 <1364920566-30040-1-git-send-email-nicolas.ferre@atmel.com>
 <20130403095150.GC27600@localhost>
 <515C067B.6070503@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515C067B.6070503@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 12:37:47PM +0200, Nicolas Ferre wrote:
> On 04/03/2013 11:51 AM, Johan Hovold :
> > On Tue, Apr 02, 2013 at 06:36:06PM +0200, Nicolas Ferre wrote:

[...]

> >> I now use a different compatibility string to figure out what is the IP
> >> revision that has the "boggus IMR" error. I think this way to handle it
> >> is much simpler than the "config" structure one from Johan.
> > 
> > I wouldn't say it's much simpler. My solution is only more generic, but
> > could of course also be reduced to "set a flag if compatible matches
> > sam9x5".
> 
> The advantage is precisely to avoid the need for a "flag". Only function
> pointers that are changed in case of the compatible string matching.

Yeah, you could do it that way. The overhead is negligible in either
solution; mask updates are infrequent and the only difference when
retrieving the mask would be to first check the flag.

An advantage of using the config-struct would perhaps be that it is same
mechanism used in i2c-at91 and atmel_lcdfb (in the arm-soc tree) to deal
with SoC-quirks and is easily extended should need arise.

The diffs of both solutions are also of roughly the same size.

But I don't have any strong preference. You decide.

[...]

> >> diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
> >> index 2a3feab..9b87053 100644
> >> --- a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
> >> +++ b/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
> >> @@ -1,7 +1,8 @@
> >>  Atmel AT91RM9200 Real Time Clock
> >>  
> >>  Required properties:
> >> -- compatible: should be: "atmel,at91rm9200-rtc"
> >> +- compatible: should be: "atmel,at91rm9200-rtc", "atmel,at91sam9x5-rtc" or
> >> +                         "atmel,at91sam9n12-rtc".
> > 
> > Also at91sam9g45 and at91sam9rl use this driver.
> 
> Yes, sure, I did not want to add every single user of the RTC...
> 
> > As seems to be the case
> > for other peripherals, I suggest we use "atmel,at91sam9x5-rtc" for
> > sam9x5 and "atmel,at91rm9200-rtc" for the other SoCs, that is, the least
> > (and first) common denominator.
> 
> ... I was just following the habit of naming the changes in peripheral
> revision by it first use in a SoC:
> at91rm9200-rtc: from rm9200 up to 9g45
> at91sam9x5-rtc: sam9x5 only (with IMR issue)
> at91sam9n12-rtc: fist SoC that corrects the IMR issue with a new IP
> revision, until now and sama5d3 SoC

Ah, ok.
 
> > Either way, there's not need to add at91sam9n12-rtc in this patch.
> > 
> >>  - reg: physical base address of the controller and length of memory mapped
> >>    region.
> >>  - interrupts: rtc alarm/event interrupt
> > 
> > I'll respond to this mail with a revert-patch, and an updated RFC-series
> > based on top of the DT-patch in Andrew's queue.

Thanks,
Johan
