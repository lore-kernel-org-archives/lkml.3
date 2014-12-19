Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaLSQ0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:26:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19333 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaLSQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:26:09 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-fe-5494519d9d74
Date: Fri, 19 Dec 2014 17:25:58 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/9] hwmon: dts: Doc: Add DTS doc to explain how to use PWM
 FAN as a cooling device
Message-id: <20141219172558.6216c1cd@amdc2363>
In-reply-to: <5492E46C.3080100@roeck-us.net>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1418897591-18332-3-git-send-email-l.majewski@samsung.com>
 <5492E46C.3080100@roeck-us.net>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoO7cwCkhBv//G1nMP3KO1WL+lWus
	FkvvfmKz+PH6AptF74KrbBZvHnFbXN41h83ic+8RRosZ5/cxWTxZeIbJ4s60vWwWh9+0szrw
	eOycdZfd48HE3Wwe66a9ZfbY+b2B3aNvyypGj82nqz0+b5ILYI/isklJzcksSy3St0vgyjg0
	5yh7wTe5iqUN19kbGO+KdzFyckgImEhcf/ucHcIWk7hwbz0biC0kMJ1RYsYa7i5GLiD7F6PE
	ot37wIpYBFQlfj1cxAxiswnoSXy++5QJxBYRUJNoPtXCBtLALLCXWeLezrtADgeHsECmxONm
	fpAaXqD6x2f6GEFsTgEdiVdXzzNDLFjKKPH98jGwzfwCkhLt/34wQ1xkJ3Hu0wZ2iGZBiR+T
	77GA2MwCWhKbtzWxQtjyEpvXvGWewCg4C0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRHEHPpHcwrmqwOMQowMGoxMPbUTg5RIg1say4MvcQowQHs5IIr6H7lBAh3pTE
	yqrUovz4otKc1OJDjNIcLErivEr2bSFCAumJJanZqakFqUUwWSYOTqkGxv748CKLur7oxKbf
	OtsNPRK11X7yqTz7c/VRG0dCw8mcySxClz9ff8tSbRL1zvD2YWn+vW9E2959Mb0UL1zPFlbi
	Z1lz8Wuu2v4tO/5rm27jjYv+fGa/glPpZtkzZcrLQ8v0vnBOXr2G66vpnIUXRQSPT+cPkXZ5
	xDV5855JCu5M5XdKtd7FKrEUZyQaajEXFScCAC31GLycAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> On 12/18/2014 02:13 AM, Lukasz Majewski wrote:
> > Several new properties to allow PWM fan working as a cooling device
> > have been combined into this single commit.
> >
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> >   .../devicetree/bindings/hwmon/pwm-fan.txt          | 28
> > ++++++++++++++++++++++ 1 file changed, 28 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt index
> > 610757c..3877810 100644 ---
> > a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt +++
> > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt @@ -3,10
> > +3,38 @@ Bindings for a fan connected to the PWM lines Required
> > properties:
> >   - compatible	: "pwm-fan"
> >   - pwms		: the PWM that is used to control the PWM
> > fan +- cooling-pwm-values      : PWM duty cycle values relative to
> > +			    cooling-max-pwm-value correspondig to
> > +			    proper cooling states
> 
> I don't understand what you mean with "relative to". Please elaborate.
> Do you mean "associated with" ?

I meant that cooling-pwm-values is no greater than
cooling-max-pwm-value (which was present in some earlier version of
this patch and had value of 255).

This description is wrong and will be reworded.

> 
> Where is "cooling-max-pwm-value" defined, 

It was present in some early version of this patch.

> and how is this all expected
> to relate to the maximum duty cycle value provided by the pwm device ?
> 
> > +- default-pulse-width     : Property specifying default pulse
> > width for FAN
> > +			    at system boot (zero to disable FAN on
> > boot).
> > +			    Allowed range is 0 to 255
> 
> You'll need dt maintainer approval for the new properties.

I'm wondering how this patch series will get merged. It touches three
different subsystems (thermal, hwmon and device tree for Exynos). 

For me it would be best to use thermal tree (hence Odroid U3 fan is
supposed to work as a cooling device) with ACKs from other subsystems
maintainers.

> 
> One thing I wonder about though is why you use "default-pulse-width"
> and not "default-pwm". Seems to be arbitrary. I don't see
> "pulse-width" used anywhere in the upstream kernel.

Believe or not I've also considered the default-pwm name.

> 
> I am somewhat concerned that you define the new properties as
> mandatory. That means existing configurations will fail, which does
> not seem to be a good idea. It would be more appropriate to not
> configure the thermal device if the new properties are not provided.

Very good point. I will do that for v2.

> 
> The newly introduced semantics also conflicts with the current
> semantics, which sets the initial duty cycle initially to the maximum
> allowed duty cycle as reported by the pwm device itself.

Ok. I will stick to above policy and then the "default-pulse-width"
property can be removed.

> 
> Guenter
> 
> > +
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
> >   Example:
> >   	pwm-fan {
> >   		compatible = "pwm-fan";
> >   		status = "okay";
> >   		pwms = <&pwm 0 10000 0>;
> > +		cooling-min-state = <0>;
> > +		cooling-max-state = <3>;
> > +		#cooling-cells = <2>;
> > +		cooling-pwm-values = <0 102 170 255>;
> > +		default-pulse-width = <0>;
> >   	};
> >
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
