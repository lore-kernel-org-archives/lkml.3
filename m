Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaGNN7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:59:30 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:52447 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbaGNN7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:59:21 -0400
Message-ID: <1405346335.13503.25.camel@iivanov-dev>
Subject: Re: [PATCH 2/3] pinctrl: Device tree bindings for Qualcomm pm8xxx
 gpio block
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Bjorn Andersson <bjorn@kryo.se>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Mon, 14 Jul 2014 16:58:55 +0300
In-Reply-To: <53C095EA.90000@codeaurora.org>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1404782785-1824-3-git-send-email-bjorn.andersson@sonymobile.com>
	 <CACRpkdZ2hekBGe1-9GV-amqi50heghWhXJ9raW7P_Nif_Ci88g@mail.gmail.com>
	 <CAJAp7OghZoTXutxw7hAsq1XA_wAhOXDNFO0tz8u9ceQ1fD9W1w@mail.gmail.com>
	 <CACRpkdai=q3nmPk5OWQWn_UMdXmqcbFXJ90rxREBG9k6gdy88Q@mail.gmail.com>
	 <53C095EA.90000@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 18:56 -0700, Stephen Boyd wrote:
> On 07/10/14 02:53, Linus Walleij wrote:
> > On Wed, Jul 9, 2014 at 11:18 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> >> On Wed, Jul 9, 2014 at 1:53 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> >>> On Tue, Jul 8, 2014 at 3:26 AM, Bjorn Andersson
> >>> <bjorn.andersson@sonymobile.com> wrote:
> >>>
> >>> +- function:
> >>> +       Usage: optional
> >>> +       Value type: <string>
> >>> +       Definition: Specify the alternative function to be configured for the
> >>> +                   specified pins.  Valid values are:
> >>> +                       "normal",
> >>> +                       "paired",
> >>> +                       "func1",
> >>> +                       "func2",
> >>> +                       "dtest1",
> >>> +                       "dtest2",
> >>> +                       "dtest3",
> >>> +                       "dtest4"
> >>> These are a bit ambigous, why doesn't the driver present functions that
> >>> are more specific than "func1", "func2"? Or "dtest1"?
> >> I agree, unfortunately I have only seen traces of the actual function matrix;
> >> for pm8xxx I have no documentation and for pm8x41 they are only listed as
> >> func[1-2] and dtest[1-4].
> >>
> >> Maybe if someone at Qualcomm could release such a list we could provide a
> >> proper table instead.
> > I guess Stephen Boyd can help us. (?)
> 
> Ok. "normal" is pretty much gpio mode, i.e. don't mux anything. "paired"
> is where we take the output of the gpio next to it and loop it back into
> this gpio (and vice versa). So gpio1 is paired with gpio2, gpio 3 is
> paired with gpio 4, etc. This allows us to make level translators by
> choosing different supply voltages for the paired gpios. "func1" and
> "func2" are used for muxing things internally. "dtest" is used to mux
> specific things out for testing purposes, not really used in any
> end-products but still useful while debugging. I can provide the
> function to pin mapping if necessary. There are lots of pmics.

Thank you Stephen. If understand it right, this is more like option for
the pin when it is GPIO. Next generation of PMIC's have support for pin
acting like analog-input/output and current sink. So I will like
to keep "function" property for selecting one of the above functions.
Choosing between "normal", "paired"... options in QPNP pinctrl driver
is supported trough passing values, defined in DT header file, to
"output-high" property. Please don't kill me :-).

> 
> >
> >>>> +- bias-pull-up:
> >>>> +       Usage: optional
> >>>> +       Value type: <u32> (optional)
> >>>> +       Definition: The specified pins should be configued as pull up. An
> >>>> +                   optional argument can be used to configure the strength.
> >>>> +                   Valid values are; as defined in
> >>>> +                   <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> >>>> +                   1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
> >>>> +                   2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
> >>>> +                   3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
> >>>> +                   4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
> >>> Hm, I don't know of the internal kernel API or so, but I'm thinking that
> >>> for the DT bindings, this definition should be generic in
> >>> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> >>> and put in SI units like uA.
> >> Totally agree with you; and this is already specified in pinctrl-binding.txt as
> >> being Ohm.
> >>
> >> So I first did a spin with the strength as a separate property, but as that
> >> because the only part that pinconf-generic didn't parse for me I merged it and
> >> wanted your comment on it.
> > Yeah. And thinking of it.... how can it be uA? It has to be Ohms... it's a pull
> > up resistor thing after all. I suspect the uA value is just something like the
> > maximum current drawn through the pullup given a certain voltage?
> >
> >>> So I would prefer:
> >>>
> >>> bias-pull-up = <30>;
> >>>
> >> Yeah, but that's the easy one ;)
> >>
> >> How do you say 1.5 or 31.5 and how do you differ that from 1.5 + 30 boot?
> > It needs to be set using Ohms.
> >
> >>> for 30 uA. Maybe we want nA even? I'm uncertain about the proper granularity
> >>> here :-/
> >>>
> >>> Magic enumerators 1,2,3,4 doesn't seem so good, that seems more like it's
> >>> trying to match the magic value that is to be poked into a register or
> >>> something like that.
> >> The stuff going into the hardware is a value 0-3 for pull up; so these values
> >> are "only" an enum with the additional benefit of saying "bias-pull-up;"
> >> results in 30uA pull up which is the most commonly used form (hence being
> >> optional).
> > What is the nominal voltage of these pins? GIven that you can figure
> > out the Ohms. And I suspect it to be something very close to N times
> > the resistance of a depleted transistor in this technology.
> 
> I believe the nominal voltage changes depending on which supply you
> choose (power-source in this document). Basically the gpio can be
> connected to different regulators on the pmic so you can choose
> different voltages, i.e. 1.8V, 3.0V, 3.3V etc. Furthermore, some of the
> regulators you can choose have variable voltage, although it may not be
> variable enough to have much effect on this. So it would seem that the
> pull-up resistance would be directly affected by which power-source is
> chosen. Maybe we just shouldn't use the generic properties for this?

+1 for custom property. "current-generator"? 

> 
> BTW, I see that power-source has made a comeback. What are the units? 

Documentation states it is "a custom format" :-).


Regards,
Ivan

