Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbaGPAXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:23:54 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55885 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759265AbaGPAXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:23:52 -0400
MIME-Version: 1.0
In-Reply-To: <1405406114.13503.40.camel@iivanov-dev>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1404782785-1824-3-git-send-email-bjorn.andersson@sonymobile.com>
	<CACRpkdZ2hekBGe1-9GV-amqi50heghWhXJ9raW7P_Nif_Ci88g@mail.gmail.com>
	<CAJAp7OghZoTXutxw7hAsq1XA_wAhOXDNFO0tz8u9ceQ1fD9W1w@mail.gmail.com>
	<CACRpkdai=q3nmPk5OWQWn_UMdXmqcbFXJ90rxREBG9k6gdy88Q@mail.gmail.com>
	<53C095EA.90000@codeaurora.org>
	<1405346335.13503.25.camel@iivanov-dev>
	<53C449A3.2010404@codeaurora.org>
	<1405406114.13503.40.camel@iivanov-dev>
Date: Tue, 15 Jul 2014 17:23:51 -0700
Message-ID: <CAJAp7OjU=FFdGKHPqovz+qrEhDCZ3E=uOSAOFbgYyLE01C9cPg@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: Device tree bindings for Qualcomm pm8xxx
 gpio block
From: Bjorn Andersson <bjorn@kryo.se>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 11:35 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> On Mon, 2014-07-14 at 14:20 -0700, Stephen Boyd wrote:
[..]
>> Isn't this document only for the gpios? I think you're talking about the
>> MPPs, which also exist on these generation of pmics. We should probably
>> avoid mixing the two (gpios and mpps) in one binding because they're
>> really different hardware.
>
> I don't know. For me "gpio" looks like function of the pin hardware.
>
>>
>> >  So I will like
>> > to keep "function" property for selecting one of the above functions.
>> > Choosing between "normal", "paired"... options in QPNP pinctrl driver
>> > is supported trough passing values, defined in DT header file, to
>> > "output-high" property. Please don't kill me :-).
>>
>> Overloading output-high to choose the MPP mode doesn't seem to follow
>> the generic pinconfig binding. Does output-high even take a value? Why
>> can't we use the function property?
>
> No, no.  using value of the output-high|low" is just to select
> "normal", "paired"... thing. Function selection is via "function"
> property. Currently QPNP support following functions "gpio", "mpp-ain",
> "mpp-aout", "mpp-cs".
>

Hi Ivan,

>From your comment I presume that you don't have access to the
documentation for these blocks.

The pmic sports two types of pins; gpios and mpps (multi-purpose-pin).
These are different hardware blocks; i.e. not a configuration thing.

The gpios can be input, output or both and they can be configured as
gpio, paired, function 1 or function 2 (+ some test modes). So here it
makes sense to have the functions "gpio", "paired" and the valid
function combinations.

The mpps can be input, output or both; in either digital or analog
mode. Or they can be a current sink. When configured as analog input
you select which adc the pin should be routed to. Here it makes sense
to have the functions "digital", "analog" and "current-sink" I think.

Regards,
Bjorn
