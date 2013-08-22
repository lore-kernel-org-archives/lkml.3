Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3HVUU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:20:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33228 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3HVUUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:20:54 -0400
Message-ID: <521672A1.6010202@wwwdotorg.org>
Date: Thu, 22 Aug 2013 14:20:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>
CC: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] documentation/devicetree: Move DT bindigns from gpio
 to watchdog
References: <1377088929-23694-1-git-send-email-johannes.thumshirn@men.de> <5214FA08.7090502@wwwdotorg.org> <20130822073740.GA3717@jtlinux>
In-Reply-To: <20130822073740.GA3717@jtlinux>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 01:37 AM, Johannes Thumshirn wrote:
> On Wed, Aug 21, 2013 at 11:34:00AM -0600, Stephen Warren wrote:
>> On 08/21/2013 06:42 AM, Johannes Thumshirn wrote:
>>> I accidently put the devicetree bindings for the MEN A21 watchdog driver in
>>> Documentation/devicetree/bindings/gpio instead of
>>> Documentation/devicetree/bindings/watchdog, this patch addresses this error.
>>
>> The rename sounds fine, so that part,
>> Acked-by: Stephen Warren <swarren@nvidia.com>
>>
>> However, the binding itself doesn't look right; it appears to have a
>> single "gpios" property rather than using separate named xxx-gpios
>> properties for different things...
> 
> Ok, so I'll need something like the following?
> 
> watchdog {
> 	compatible ="men,a021-wdt";
> 	enable-gpios = <&gpio3 9 1>; /* WD_EN */
> 	fast-gpios = <&gpio3 10 1>;  /* WD_FAST */
> 	trig-gpios = <&gpio3 11 1>;  /* WD_TRIG */
> 	rst0-gpio = <&gpio3 6 1>;    /* RST_CAUSE[0] */
> 	rst1-gpio = <&gpio3 7 1>;    /* RST_CAUSE[1] */
> 	rst2-gpio = <&gpio3 8 1>;    /* RST_CAUSE[2] */
> };

Yes, that looks more like what I'd expect, albeit I'd probably expect to
see a rst-gpio property with 3 entries.

> Or is there something like of_get_named_gpios(...) so I can put all 3 rst-gpios
> into one property? A quick grep only revealed of_get_named_gpio(...).

The availablity of APIs within Linux shouldn't impact the binding
definitions. I would imagine it's easy enough to add
of_get_named_gpio_by_index() or similar to Linux.

