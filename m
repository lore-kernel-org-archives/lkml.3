Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbbANPIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:08:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55595 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbbANPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:08:27 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-7b-54b6866946ac
Date: Wed, 14 Jan 2015 16:07:53 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v2 2/8] thermal: Provide stub for thermal_cdev_update()
 function
Message-id: <20150114160753.48f903da@amdc2363>
In-reply-to: <20150102184028.GA12371@developer>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-3-git-send-email-l.majewski@samsung.com>
 <20150102184028.GA12371@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd3Mtm0hBju/yVk8XrOYyWL+kXOs
	FvOvXGO1WHr3E5vFj9cX2CzW/FWy6F1wlc3izSNui8u75rBZfO49wmgx4/w+JosnC88wWdyZ
	tpfN4vCbdlYHPo+ds+6yezyYuJvNY920t8weO783sHv0bVnF6LH5dLXH501yAexRXDYpqTmZ
	ZalF+nYJXBkz7j9iLvggXHFpakAD4ySBLkZODgkBE4lHe54yQ9hiEhfurWfrYuTiEBJYxCjx
	7c1EJgjnF6PE9dNb2UCqWARUJVqfrGUEsdkE9CQ+333KBGKLCGhJnLi0HayBWWAai8Tq673s
	IAlhgTCJLQ9vgtm8QA1/rz4Fa+YU0Jd4cGUvK8SGp4wSk6euAbuDX0BSov3fD6ib7CTOfdoA
	1Swo8WPyPRYQmxlo2+ZtTawQtrzE5jVvmScwCs5CUjYLSdksJGULGJlXMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgRH1TPpHYyrGiwOMQpwMCrx8Doc2RoixJpYVlyZe4hRgoNZSYT3afm2
	ECHelMTKqtSi/Pii0pzU4kOM0hwsSuK8SvZtIUIC6YklqdmpqQWpRTBZJg5OqQbGcu/vv0V9
	LC38bicsM3i/6KrI+zvtnTI8jw0faF/KXrhpQfwu1slmGzflxCzg1XhkzWX6LYzdvdb6T8KE
	xx0PYj9l8354VpgZ/UExL2/+r0uzzi0Qjk6t+V92yMj1buTprdytv/NObHz7QPyJe9F9nh05
	n4IzFNf35qekua7YIOFh05HZ8nS3EktxRqKhFnNRcSIANgjB5qYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On Mon, Dec 22, 2014 at 05:27:42PM +0100, Lukasz Majewski wrote:
> > Odroid U3 fan can work without being registered as OF cooling device
> > (with CONFIG_THERMAL_OF disabled).
> > In this situation it can be controlled via PWM entry at
> > /sys/class/hwmon/hwmon0/pwm1.
> > 
> > Therefore, the thermal_cdev_update() function needs a stub
> > to allow clean compilation.
> 
> I am not sure I understand what you are attempting to do here. What is
> the relation that you see between CONFIG_OF_THERMAL and
> thermal_cdev_update? 

It should be CONFIG_THERMAL, not CONFIG_OF_THERMAL.

The thermal_cdev_update() is necessary since pwm-fan code can be
run without THERMAL subsystem (and such configuration is perfectly
valid).

> 
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> > Changes for v2:
> > - New patch
> > ---
> >  include/linux/thermal.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > index 871123c..b3515b5 100644
> > --- a/include/linux/thermal.h
> > +++ b/include/linux/thermal.h
> > @@ -332,6 +332,7 @@ struct thermal_cooling_device *
> >  thermal_of_cooling_device_register(struct device_node *np,
> >  				   char *type, void *devdata,
> >  				   const struct
> > thermal_cooling_device_ops *); +void thermal_cdev_update(struct
> > thermal_cooling_device *); #else
> >  static inline struct thermal_zone_device *
> >  thermal_zone_of_sensor_register(struct device *dev, int id, void
> > *data, @@ -353,6 +354,10 @@
> > thermal_of_cooling_device_register(struct device_node *np, {
> >  	return NULL;
> >  }
> > +
> > +static inline void thermal_cdev_update(struct
> > thermal_cooling_device *cdev) +{
> > +}
> >  #endif
> >  struct thermal_zone_device *thermal_zone_device_register(const
> > char *, int, int, void *, struct thermal_zone_device_ops *,
> > @@ -375,7 +380,6 @@ int thermal_zone_get_temp(struct
> > thermal_zone_device *tz, unsigned long *temp); int
> > get_tz_trend(struct thermal_zone_device *, int); struct
> > thermal_instance *get_thermal_instance(struct thermal_zone_device
> > *, struct thermal_cooling_device *, int); -void
> > thermal_cdev_update(struct thermal_cooling_device *); void
> > thermal_notify_framework(struct thermal_zone_device *, int); 
> >  #ifdef CONFIG_NET
> > -- 
> > 2.0.0.rc2
> > 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
