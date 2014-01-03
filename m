Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaACLKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:10:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:49728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaACLKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:10:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,597,1384329600"; 
   d="scan'208";a="461162539"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Anton Vorontsov <anton@enomsg.org>,
        =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "freemangordon@abv.bg" <freemangordon@abv.bg>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "pavel@ucw.cz" <pavel@ucw.cz>
Subject: RE: [PATCH v2 1/3] power_supply: Add power_supply notifier
Thread-Topic: [PATCH v2 1/3] power_supply: Add power_supply notifier
Thread-Index: AQHO5RFDfa/cA+i2sUmlOXctUUhQ1Zo/oZYAgDN7/hA=
Date: Fri, 3 Jan 2014 11:09:49 +0000
Message-ID: <20ADAB092842284E95860F279283C56422D1AD1E@BGSMSX104.gar.corp.intel.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-2-git-send-email-pali.rohar@gmail.com>
 <20131201222330.GB6271@lizard>
In-Reply-To: <20131201222330.GB6271@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s03BAHbi022157

Anton,

I don't see this patch in Linux tree. Any update on this would be helpful

Thanks
Jenny

> -----Original Message-----
> From: Anton Vorontsov [mailto:anton@scarybugs.org] On Behalf Of Anton
> Vorontsov
> Sent: Monday, December 02, 2013 3:54 AM
> To: Pali RohÃ¡r
> Cc: David Woodhouse; Tony Lindgren; Russell King; linux-kernel@vger.kernel.org;
> linux-omap@vger.kernel.org; freemangordon@abv.bg; aaro.koskinen@iki.fi;
> pavel@ucw.cz; Tc, Jenny
> Subject: Re: [PATCH v2 1/3] power_supply: Add power_supply notifier
> 
> On Tue, Nov 19, 2013 at 11:18:03AM +0100, Pali RohÃ¡r wrote:
> > This patch adds a notifier chain to the power_supply.
> > This notifier helps drivers in other subsystem to listen to changes in
> > power supply subsystem. This would help to take some actions in those
> > drivers on changing the power supply properties.
> > One such scenario is to increase/decrease system performance based on
> > the battery capacity/voltage. Another scenario is to adjust the h/w
> > peak current detection voltage/current thresholds based on battery
> > voltage/capacity. The notifier helps drivers to listen to changes in
> > power_suppy susbystem without polling the power_supply properties
> >
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > Signed-off-by: Pali RohÃ¡r <pali.rohar@gmail.com>
> ...
> > +enum power_supply_notifier_events {
> > +	PSY_EVENT_NONE,
> 
> This one is not needed.
> 
> > +	PSY_EVENT_PROP_CHANGED,
> > +	PSY_EVENT_BATTERY,
> > +	PSY_EVENT_CABLE,
> > +};
> 
> The only event that is currently used in your patch series is
> EVENT_PROP_CHANGED... So, I applied the patch with the following changes:
> 
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h index
> c6f52c0..0c2a260 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -15,6 +15,7 @@
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/device.h>
> +#include <linux/notifier.h>
>  #include <linux/err.h>
>  #include <linux/power_supply.h>
>  #include <linux/thermal.h>
> @@ -159,10 +159,7 @@ enum power_supply_type {  };
> 
>  enum power_supply_notifier_events {
> -	PSY_EVENT_NONE,
>  	PSY_EVENT_PROP_CHANGED,
> -	PSY_EVENT_BATTERY,
> -	PSY_EVENT_CABLE,
>  };
> 
>  union power_supply_propval {
> @@ -242,7 +239,7 @@ struct power_supply_info {
>  	int use_for_apm;
>  };
> 
> -extern struct atomic_notifier_head    power_supply_notifier;
> +extern struct atomic_notifier_head power_supply_notifier;
>  extern int power_supply_reg_notifier(struct notifier_block *nb);  extern void
> power_supply_unreg_notifier(struct notifier_block *nb);  extern struct
> power_supply *power_supply_get_by_name(const char *name);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
