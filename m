Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaCLO6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:58:16 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44977 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbaCLO6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:58:12 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] dt-bindings: document gpio-charger bindings
Date: Wed, 12 Mar 2014 15:57:18 +0100
Message-ID: <4446481.1MqT47xhP8@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAL_JsqKoOhHpJ_OL23WbitQbiJJKLpWrtezT824FP0qtZ2xrEg@mail.gmail.com>
References: <12569216.pGctOhkhxz@phil> <2194340.F9etmr5mIo@phil> <CAL_JsqKoOhHpJ_OL23WbitQbiJJKLpWrtezT824FP0qtZ2xrEg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Am Mittwoch, 12. März 2014, 09:28:46 schrieb Rob Herring:
> On Wed, Mar 12, 2014 at 8:46 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > From: Heiko Stuebner <heiko.stuebner@bq.com>
> > 
> > This documents the binding for the gpio-charger power-supply.
> 
> How does this relate to what's documented in power_supply.txt and
> charger-manager.txt? Both have references to USB charging. Doesn't
> this need some connection to a battery node?

Yep, the gpio-charger takes the position of the "some,usb-charger" from 
power_supply.txt .

       usb_charger: charger {
               compatible = "gpio-charger";
               charger-type = "usb-sdp";
               gpios = <&gpf0 2 0 0 0>;
       }

       battery {
               power-supplies = <&usb_charger>;
       };


I guess the binding doc could reflect this.


I haven't deeply looked into what charger-manager does, bit it seems to be a 
layer on top of chargers and batteries, controlling them. So it seems to be 
used with more intelligent components.

My setup using gpio-charger for example is vastly simpler, it's just a gpio 
reporting charger present (for gpio-charger), an adc reporting the battery 
voltage and another gpio reporting the charging state (which is already 
handled in generic-adc-battery, but needs a dt binding too).


Heiko

> > Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
> > ---
> > 
> >  .../bindings/power_supply/gpio-charger.txt         | 23
> >  ++++++++++++++++++++++ 1 file changed, 23 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/power_supply/gpio-charger.txt> 
> > diff --git
> > a/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
> > b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt new
> > file mode 100644
> > index 0000000..fad87a4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
> > @@ -0,0 +1,23 @@
> > +gpio-charger
> > +
> > +Required properties :
> > + - compatible : "gpio-charger"
> > + - gpios : GPIO indicating the charger presence.
> > +   See GPIO binding in bindings/gpio/gpio.txt .
> > + - charger-type : power supply type, one of
> > +     unknown
> > +     battery
> > +     ups
> > +     mains
> > +     usb-sdp (USB standard downstream port)
> > +     usb-dcp (USB dedicated charging port)
> > +     usb-cdp (USB charging downstream port)
> > +     usb-aca (USB accessory charger adapter)
> > +
> > +Example:
> > +
> > +       charger {
> > +               compatible = "gpio-charger";
> > +               charger-type = "usb-sdp";
> > +               gpios = <&gpf0 2 0 0 0>;
> > +       }
> > --
> > 1.8.5.3

