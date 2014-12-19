Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaLSQNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:13:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47715 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLSQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:13:14 -0500
X-AuditID: cbfee61a-f79c06d000004e71-f2-54944e96e922
Date: Fri, 19 Dec 2014 17:13:01 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/9] hwmon: dts: Doc: Add DTS doc to explain how to use PWM
 FAN as a cooling device
Message-id: <20141219171301.1527d81e@amdc2363>
In-reply-to: <20141219160237.GA2199@roeck-us.net>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1418897591-18332-3-git-send-email-l.majewski@samsung.com>
 <1418899337.23532.9.camel@collabora.co.uk> <20141219163224.34796e5d@amdc2363>
 <20141219160237.GA2199@roeck-us.net>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAd1pflNCDH7/V7CYf+Qcq8X8K9dY
	LZbe/cRm8eP1BTaL3gVX2SzePOK2uLxrDpvF594jjBYzzu9jsniy8AyTxZ1pe9ksDr9pZ7WY
	fvwtqwOvx9/n11k8ds66y+7xYOJuNo91094ye+z83sDu0bdlFaPH5tPVHp83yQVwRHHZpKTm
	ZJalFunbJXBlfD0mUHBLqmLNpTnsDYybRboYOTgkBEwkrr8K6WLkBDLFJC7cW8/WxcjFISSw
	iFHi1Y1t7CAJIYFfjBKtZ7NBbBYBVYn7O7awgthsAnoSn+8+ZQKxRQTUJJpPtYA1Mwu8Y5ZY
	1LyLBWSBsECmxONmfpAaXqD6lg8HwHo5BQwldv9fygKxDGh+y+5OZpAEv4CkRPu/H8wQF9lJ
	nPu0gR2iWVDix+R7LCA2s4CWxOZtTawQtrzE5jVvmScwCs5CUjYLSdksJGULGJlXMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgRH1DOpHYwrGywOMQpwMCrx8HYUTg4RYk0sK67MPcQowcGs
	JMJr6D4lRIg3JbGyKrUoP76oNCe1+BCjNAeLkjivkn1biJBAemJJanZqakFqEUyWiYNTqoFx
	xsNp75RdqrasWl87N71qZ/ymmUtL7lxwDm/eNCVwLneP+ZMIsfTdr8UYAgy0Wgw51zEvcXz2
	ZiHjhOkXjKW29zp06GjUcimmrIl9mtRZwe45mX3/4yzRuQteFV+Z/MfVLn2195VdQrUJnk+6
	6rliytVONE2aIy9yJb5zU99/Ze95H1+2qroosRRnJBpqMRcVJwIAI67WpqQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> On Fri, Dec 19, 2014 at 04:32:24PM +0100, Lukasz Majewski wrote:
> > Hi Sjoerd,
> > 
> > Thanks for your feedback and sorry for a late reply.
> > 
> > > On Thu, 2014-12-18 at 11:13 +0100, Lukasz Majewski wrote:
> > > > Several new properties to allow PWM fan working as a cooling
> > > > device have been combined into this single commit.
> > > > 
> > > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > > ---
> > > >  .../devicetree/bindings/hwmon/pwm-fan.txt          | 28
> > > > ++++++++++++++++++++++ 1 file changed, 28 insertions(+)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > > > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt index
> > > > 610757c..3877810 100644 ---
> > > > a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt +++
> > > > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt @@ -3,10
> > > > +3,38 @@ Bindings for a fan connected to the PWM lines Required
> > > > properties:
> > > >  - compatible	: "pwm-fan"
> > > >  - pwms		: the PWM that is used to control the
> > > > PWM fan +- cooling-pwm-values      : PWM duty cycle values
> > > > relative to
> > > > +			    cooling-max-pwm-value correspondig
> > > > to
> > > > +			    proper cooling states
> > > > +- default-pulse-width     : Property specifying default pulse
> > > > width for FAN
> > > > +			    at system boot (zero to disable
> > > > FAN on boot).
> > > > +			    Allowed range is 0 to 255
> > > 
> > > The 0..255 range seems somewhat random. Would be nicer to either
> > > use the approach of pwm-backlight (iotw, have the range go from
> > > the first to the last entry of cooling-pwm-values) 
> > 
> > I'm OK to change the default-pulse-width to be similar to
> > "default-brightness-level" (as it is in
> > Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt)
> > 
> > > or simply have be the duty
> > > lenght in NS as entries instead of the current indirection.
> > 
> > I'd prefer to keep the indirection - as it is utilized in the
> > current pwm-fan.c driver.
> > 
> FWIW, devicetree information is supposed to be implementation
> independent. So this is a poor argument.

Many other pwm drivers use the indirection - e.g. mentioned
pwm-backlight.


> 
> > 
> > Enabling pan to full RPM was the default behaviour in the current
> > pwm-fan.c file.
> > 
> > To be honest, there is no need to enable fan to full RPM speed in
> > this board for following reasons:
> > 1. In Odroid the FAN is optional (stacked on top of a heat sink) -
> > very often it is just enough to only have the heat sink.
> > 
> > 2. Odroid has thermal enabled by default and IMHO it would be more
> > feasible to allow thermal to control fan from the very beginning.
> > 
> > However, I can also understand if the policy for hwmon implies a
> > rule to enable by default all fans to full RPM speed.
> > 
> Why and how does that all suggest that the current default behavior
> should be changed ?

I wanted to avoid the unpleasant sound for full speed fan when thermal
is not enabled by default.

But as I said, I fully understand the policy and I would be happy to
comply with it as thermal should reduce the fan speed anyway at boot
time.

> 
> Guenter



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
