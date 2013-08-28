Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3H1AMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 20:12:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:44876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab3H1AMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 20:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,971,1367996400"; 
   d="scan'208";a="392969395"
Message-ID: <1377648836.2335.252.camel@rzhang-lenovo>
Subject: Re: [PATCH 3/5] drivers: thermal: make usage of
 CONFIG_THERMAL_HWMON optional
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Peter Feuerer <peter@piie.net>, platform-driver-x86@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Date: Wed, 28 Aug 2013 08:13:56 +0800
In-Reply-To: <8131326.8QGX41MW6c@vostro.rjw.lan>
References: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com>
	 <4832825.8PCMQe7StP@vostro.rjw.lan> <521CEF61.6040504@ti.com>
	 <8131326.8QGX41MW6c@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 二, 2013-08-27 at 23:17 +0200, Rafael J. Wysocki wrote:
> On Tuesday, August 27, 2013 02:26:41 PM Eduardo Valentin wrote:
> > On 23-08-2013 19:08, Rafael J. Wysocki wrote:
> > > On Friday, August 23, 2013 06:03:14 PM Eduardo Valentin wrote:
> > >> When registering a new thermal_device, the thermal framework
> > >> will always add a hwmon sysfs interface.
> > >>
> > >> This patch adds a flag to make this behavior optional. Now
> > >> when registering a new thermal device, the caller needs
> > >> to say if the hwmon interface is required.
> > >>
> > >> In order to keep same behavior as of today, all current
> > >> calls will by default create the hwmon interface.
> > > 
> > > Well, instead of modifying all of the callers this way, why don't
> > > you add new versions taking the additional argument as, for example,
> > > 
> > > thermal_zone_device_register_full()
> > > 
> > > and redefine the old ones as static inline wrappers, for example
> > > 
> > > static inline struct thermal_zone_device *thermal_zone_device_register(args)
> > > {
> > > 	return thermal_zone_device_register_full(args, true);
> > > }
> > > 
> > > ?
> > 
> > Yeah, that is another way to go and I thought of doing it like that. I
> > just could not come out with a good API naming:
> > 
> > thermal_zone_device_register_full(all args)
> > 
> > thermal_zone_device_register(args) /* on hwmon == true */
> > thermal_zone_device_register_no_hwmon(args) /* on hwmon == false */
> > 
> > Would this sound reasonable naming?
> 
> Yeah, sounds good to me.
> 
Well, actually, Tianyu is working on a patch set to move all the
thermal_zone_device_register() parameters to struct thermal_zone_params.

But with that patch set done, what you need to do next is just to
introduce a new field in struct thermal_zone_params and make sure 0
means registering hwmon sysfs I/F.

thanks,
rui

> Thanks,
> Rafael
> 


