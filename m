Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3H0VHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:07:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37705 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3H0VHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:07:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, rui.zhang@intel.com,
        linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Peter Feuerer <peter@piie.net>, platform-driver-x86@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/5] drivers: thermal: make usage of CONFIG_THERMAL_HWMON optional
Date: Tue, 27 Aug 2013 23:17:38 +0200
Message-ID: <8131326.8QGX41MW6c@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <521CEF61.6040504@ti.com>
References: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com> <4832825.8PCMQe7StP@vostro.rjw.lan> <521CEF61.6040504@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 27, 2013 02:26:41 PM Eduardo Valentin wrote:
> On 23-08-2013 19:08, Rafael J. Wysocki wrote:
> > On Friday, August 23, 2013 06:03:14 PM Eduardo Valentin wrote:
> >> When registering a new thermal_device, the thermal framework
> >> will always add a hwmon sysfs interface.
> >>
> >> This patch adds a flag to make this behavior optional. Now
> >> when registering a new thermal device, the caller needs
> >> to say if the hwmon interface is required.
> >>
> >> In order to keep same behavior as of today, all current
> >> calls will by default create the hwmon interface.
> > 
> > Well, instead of modifying all of the callers this way, why don't
> > you add new versions taking the additional argument as, for example,
> > 
> > thermal_zone_device_register_full()
> > 
> > and redefine the old ones as static inline wrappers, for example
> > 
> > static inline struct thermal_zone_device *thermal_zone_device_register(args)
> > {
> > 	return thermal_zone_device_register_full(args, true);
> > }
> > 
> > ?
> 
> Yeah, that is another way to go and I thought of doing it like that. I
> just could not come out with a good API naming:
> 
> thermal_zone_device_register_full(all args)
> 
> thermal_zone_device_register(args) /* on hwmon == true */
> thermal_zone_device_register_no_hwmon(args) /* on hwmon == false */
> 
> Would this sound reasonable naming?

Yeah, sounds good to me.

Thanks,
Rafael

