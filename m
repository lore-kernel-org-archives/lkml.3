Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3HPRU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:20:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55275 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631Ab3HPRUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:20:25 -0400
Date: Fri, 16 Aug 2013 18:20:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Benoit Cousson <bcousson@baylibre.com>
Cc: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sudhakar.raj@ti.com" <sudhakar.raj@ti.com>
Subject: Re: [PATCH v3 1/2] rtc: omap: update of_device_id to reflect
 latest ip revisions
Message-ID: <20130816172022.GA3719@e106331-lin.cambridge.arm.com>
References: <1376653017-21935-1-git-send-email-gururaja.hebbar@ti.com>
 <1376653017-21935-2-git-send-email-gururaja.hebbar@ti.com>
 <520E341D.4080206@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E341D.4080206@baylibre.com>
Thread-Topic: [PATCH v3 1/2] rtc: omap: update of_device_id to reflect
 latest ip revisions
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Fri, Aug 16, 2013 at 03:15:57PM +0100, Benoit Cousson wrote:
> Hi Gururaja,
> 
> On 16/08/2013 13:36, Hebbar, Gururaja wrote:
> > The syntax of compatible property in DT is to mention the Most specific
> > match to most generic match.
> >
> > Since AM335x is the platform with latest IP revision, add it 1st in
> > the device id table.
> 
> I don't understand why? The order should not matter at all.
> 
> I've tried to follow the thread you had with Mark on the v2, but AFAIK, 
> you've never answered to his latest question.
> 
> Moreover, checking the differences between the Davinci and the am3352 
> RTC IP, I would not claim that both are compatible.
> 
> Sure you can use the am3352 with the Davinci driver, but you will lose 
> the wakeup functionality without even being notify about that.

Could you describe the wakeup functionality, and how it differs between
the am3352-rtc and the da830-rtc?

As I understand it, the am3352 functionality is a superset of the da830
functionality. You can use the old driver, and get some functionality,
or use the new driver and get it all.

That means that am3352-rtc is compatible with da830. As long as the
kernel first checks for am3352-rtc, there will be *no* loss of
functionality. All this does is enable older kernels to use the hardware
in some fashion, and given the older kernel didn't have support for the
am3352-rtc features, this is a *gain* in functionality, not a loss.

> 
> For my point of view, compatible mean that the HW will still be fully 
> functional with both versions of the driver, which is not the case here.

What? A driver for any entry in the compatible list should be able to
drive the hardware to *some* level of functionality. We list from
most-specific to most-general to allow a graceful degradation from fully
supported to bare minimum functionality.

> 
> am3352 DTS must use the ti,am3352-rtc to have the expected behavior. 
> Using the ti,da830-rtc version will not make the board working as 
> expected. So we cannot claim the compatibility.

Please can you explain what you mean by "expected behaviour"?

> 
> > This way, we can add new matching compatible as 1st and maintain old
> > compatible string for backwards compatibility.
> >
> > ex:
> > 	compatible = "ti,am3352-rtc", "ti,da830-rtc";
> >
> > Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
> > CC: mark.rutland@arm.com
> > ---
> > Changes in v3:
> > 	- new patch
> >
> > :100644 100644 dc62cc3... 2f0968c... M	drivers/rtc/rtc-omap.c
> >   drivers/rtc/rtc-omap.c |    6 +++---
> >   1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> > index dc62cc3..2f0968c 100644
> > --- a/drivers/rtc/rtc-omap.c
> > +++ b/drivers/rtc/rtc-omap.c
> > @@ -330,12 +330,12 @@ static struct platform_device_id omap_rtc_devtype[] = {
> >   MODULE_DEVICE_TABLE(platform, omap_rtc_devtype);
> >
> >   static const struct of_device_id omap_rtc_of_match[] = {
> > -	{	.compatible	= "ti,da830-rtc",
> > -		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
> > -	},
> >   	{	.compatible	= "ti,am3352-rtc",
> >   		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_AM335X_IDX],
> >   	},
> > +	{	.compatible	= "ti,da830-rtc",
> > +		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
> > +	},
> >   	{},
> >   };
> >   MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
> 
> Bottom-line, if you get rid of the old compatible entry, you will not 
> have to play some trick with the entries order.

I don't think it's playing tricks. It's ensuring compatibility, and it's
a simple change in ordering.

Thanks,
Mark.
