Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaLSPck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:32:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61211 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaLSPch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:32:37 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-8b-5494451284fb
Date: Fri, 19 Dec 2014 16:32:24 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/9] hwmon: dts: Doc: Add DTS doc to explain how to use PWM
 FAN as a cooling device
Message-id: <20141219163224.34796e5d@amdc2363>
In-reply-to: <1418899337.23532.9.camel@collabora.co.uk>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1418897591-18332-3-git-send-email-l.majewski@samsung.com>
 <1418899337.23532.9.camel@collabora.co.uk>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAV1h1ykhBn/2s1rMP3IOSFy5xmqx
	9O4nNosfry+wWfQuuMpm8eYRt8XlXXPYLD73HmG0mHF+H5PFk4VnmCzuTNvLZnH4TTurxfTj
	b1kdeD3+Pr/O4rFz1l12jwcTd7N5rJv2ltlj5/cGdo++LasYPTafrvb4vEkugCOKyyYlNSez
	LLVI3y6BK+P9+0eMBeflK260fmRrYNws0cXIySEhYCKx4OF0RghbTOLCvfVsXYxcHEICixgl
	ur9dYoVwfjFKvNrwjw2kikVAVeLko0ssIDabgJ7E57tPmUBsEQFDiR9zvjCCNDALPGaWuHqp
	ASjBwSEskCnxuJkfpIYXqH5D5x2wbZwC5hLfp+4EmyMksIFRYnsPB4jNLyAp0f7vBzPERXYS
	5z5tYIfoFZT4MfkeWD2zgJbE5m1NrBC2vMTmNW+ZJzAKzkJSNgtJ2SwkZQsYmVcxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBEfVM+kdjKsaLA4xCnAwKvHwdhRODhFiTSwrrsw9xCjBwawk
	wmtuPSVEiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+SfVuIkEB6YklqdmpqQWoRTJaJg1OqgbF6
	w3Ertdd9sQdXhr6Wj1mldTU5f+/rek22icdtF0SEMbEJLpIRe7fX5uWDN8l8r/5eCfPh7eVe
	uYnzBLdhzbxPm1ouSWcwfnv3+dlLzWe7f4ae2BO11E/tPze/xLUXchH/C+fzTtrrwKRt1J+l
	+fX1bw01N5FqLo7cK5HTyiW3MMjem/4qfb8SS3FGoqEWc1FxIgCiWjC3pgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjoerd,

Thanks for your feedback and sorry for a late reply.

> On Thu, 2014-12-18 at 11:13 +0100, Lukasz Majewski wrote:
> > Several new properties to allow PWM fan working as a cooling device
> > have been combined into this single commit.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> >  .../devicetree/bindings/hwmon/pwm-fan.txt          | 28
> > ++++++++++++++++++++++ 1 file changed, 28 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt index
> > 610757c..3877810 100644 ---
> > a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt +++
> > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt @@ -3,10
> > +3,38 @@ Bindings for a fan connected to the PWM lines Required
> > properties:
> >  - compatible	: "pwm-fan"
> >  - pwms		: the PWM that is used to control the PWM fan
> > +- cooling-pwm-values      : PWM duty cycle values relative to
> > +			    cooling-max-pwm-value correspondig to
> > +			    proper cooling states
> > +- default-pulse-width     : Property specifying default pulse
> > width for FAN
> > +			    at system boot (zero to disable FAN on
> > boot).
> > +			    Allowed range is 0 to 255
> 
> The 0..255 range seems somewhat random. Would be nicer to either use
> the approach of pwm-backlight (iotw, have the range go from the first
> to the last entry of cooling-pwm-values) 

I'm OK to change the default-pulse-width to be similar to
"default-brightness-level" (as it is in
Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt)

> or simply have be the duty
> lenght in NS as entries instead of the current indirection.

I'd prefer to keep the indirection - as it is utilized in the current
pwm-fan.c driver.

> 
> I assumed your cooling-pwm-values are a [0..255] range as well instead
> of nanoseconds (would be good to make that more clear)?

Your assumption is correct. cooling-pwm-values are indeed in the
[0..255] range. I will add this information in v2.

> 
> Also having more consistent names would be nice.. To take
> pwm-backlight as inspiration, cooling-levels and
> default-cooling-level would make it more clear the second property
> picks a default setting from the first one.

I agree.

> 
> One thing i do wonder, is having an explicit default setting useful?
> Should it not default to maximum cooling unless otherwise configured
> by either the thermal framework or sysfs ?

Enabling pan to full RPM was the default behaviour in the current
pwm-fan.c file.

To be honest, there is no need to enable fan to full RPM speed in this
board for following reasons:
1. In Odroid the FAN is optional (stacked on top of a heat sink) - very
often it is just enough to only have the heat sink.

2. Odroid has thermal enabled by default and IMHO it would be more
feasible to allow thermal to control fan from the very beginning.

However, I can also understand if the policy for hwmon implies a rule
to enable by default all fans to full RPM speed.

> 
> 
> > +Thorough description of the following bindings:
> > +		cooling-min-state = <0>;
> > +		cooling-max-state = <3>;
> > +		#cooling-cells = <2>;
> > +		thermal-zone {
> > +			cpu_thermal: cpu-thermal {
> > +			cooling-maps {
> > +				map0 {
> > +				     trip = <&cpu_alert1>;
> > +				     cooling-device = <&fan0 0 1>;
> > +				};
> > +			};
> > +		};
> > +
> > +for PWM FAN used as cooling device can be found at:
> > +./Documentation/devicetree/bindings/thermal/thermal.txt
> >  
> >  Example:
> >  	pwm-fan {
> >  		compatible = "pwm-fan";
> >  		status = "okay";
> >  		pwms = <&pwm 0 10000 0>;
> > +		cooling-min-state = <0>;
> > +		cooling-max-state = <3>;
> > +		#cooling-cells = <2>;
> > +		cooling-pwm-values = <0 102 170 255>;
> > +		default-pulse-width = <0>;
> >  	};
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
