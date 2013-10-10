Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3JJUrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:47:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55744 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3JJUr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:47:29 -0400
Message-ID: <5257125C.2030007@wwwdotorg.org>
Date: Thu, 10 Oct 2013 14:47:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
CC: Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 01/03] Make non-linear GPIO ranges accesible from gpiolib
References: <20131008122145.GA21985@ab42.lan>	<1381235122-23730-1-git-send-email-christian.ruppert@abilis.com> <CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
In-Reply-To: <CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 05:58 AM, Linus Walleij wrote:
> On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
> <christian.ruppert@abilis.com> wrote:
>> This patch adds the infrastructure required to register non-linear gpio
>> ranges through gpiolib and the standard GPIO device tree bindings.
...
>> +Example:
>> +
>> +       gpio_pio_i: gpio-controller@14B0 {
>> +               #gpio-cells = <2>;
>> +               compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
>> +               reg = <0x1480 0x18>;
>> +               gpio-controller;
>> +               gpio-ranges =                   <&pinctrl1 0 20 10>,
>> +                                               <&pinctrl2 10 0 0>,
>> +                                               <&pinctrl1 15 0 10>,
>> +                                               <&pinctrl2 25 0 0>;
>> +               gpio-ranges-group-names =       "",
>> +                                               "foo",
>> +                                               "",
>> +                                               "bar";
>> +       };
> 
> And here, I get a bit uneasy as I remember Stephen's stance that such
> groups must be a physical property of the controller. I am generally a
> bit soft on that, but that is from a driver point of view, and describing
> hardware in the devicetree must be reflecting an objective view of the
> hardware, not how the particular driver is written for Linux.
> 
> This is very questionable :-/

I think describing the GPIO ranges is an aspect of the HW; it's
describing actual routing of signal lines between the GPIO and pinctrl
HW blocks. It seems reasonable for DT to describe that concept (although
perhaps the actual mapping could be part of some driver rather than DT,
but that's a separate issue).

Using groups to describe aspects of this mapping doesn't seem totally
unreasonable either. We have named groups for muxing, which is a real HW
property. We can have named groups for GPIO/pinctrl routing, which again
is a HW property. Certainly in the muxing case, and hopefully for this
case too, the naming of those groups is driven purely by the HW design
of the SoC top-level or GPIO/pinctrl HW blocks, and hence it's
reasonable for a DT binding to define (or rather, use) those names.
Hopefully different OSs don't use different names for the groups, since
the naming is derived directly from HW.
