Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3HVHi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:38:26 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.164]:26168 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702Ab3HVHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:38:24 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-39.messagelabs.com!1377157100!2416586!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 22 Aug 2013 09:38:20 +0200
Date: Thu, 22 Aug 2013 09:37:42 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] documentation/devicetree: Move DT bindigns from gpio to
 watchdog
Message-ID: <20130822073740.GA3717@jtlinux>
References: <1377088929-23694-1-git-send-email-johannes.thumshirn@men.de>
 <5214FA08.7090502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5214FA08.7090502@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 22 Aug 2013 07:38:19.0348 (UTC) FILETIME=[924F4140:01CE9F0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:34:00AM -0600, Stephen Warren wrote:
> On 08/21/2013 06:42 AM, Johannes Thumshirn wrote:
> > I accidently put the devicetree bindings for the MEN A21 watchdog driver in
> > Documentation/devicetree/bindings/gpio instead of
> > Documentation/devicetree/bindings/watchdog, this patch addresses this error.
>
> The rename sounds fine, so that part,
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> However, the binding itself doesn't look right; it appears to have a
> single "gpios" property rather than using separate named xxx-gpios
> properties for different things...

Ok, so I'll need something like the following?

watchdog {
	compatible ="men,a021-wdt";
	enable-gpios = <&gpio3 9 1>; /* WD_EN */
	fast-gpios = <&gpio3 10 1>;  /* WD_FAST */
	trig-gpios = <&gpio3 11 1>;  /* WD_TRIG */
	rst0-gpio = <&gpio3 6 1>;    /* RST_CAUSE[0] */
	rst1-gpio = <&gpio3 7 1>;    /* RST_CAUSE[1] */
	rst2-gpio = <&gpio3 8 1>;    /* RST_CAUSE[2] */
};

Or is there something like of_get_named_gpios(...) so I can put all 3 rst-gpios
into one property? A quick grep only revealed of_get_named_gpio(...).

Thanks,
Johannes
