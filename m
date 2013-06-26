Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3FZRfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:35:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58430 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3FZRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:35:00 -0400
Message-ID: <51CB2641.1010404@wwwdotorg.org>
Date: Wed, 26 Jun 2013 11:34:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 1/4] Make non-linear GPIO ranges accesible from gpiolib
References: <20130618092516.GC18663@ab42.lan> <1371547751-13873-1-git-send-email-christian.ruppert@abilis.com> <51C23060.50807@wwwdotorg.org> <20130626114654.GB7095@ab42.lan>
In-Reply-To: <20130626114654.GB7095@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 05:46 AM, Christian Ruppert wrote:
> On Wed, Jun 19, 2013 at 04:27:44PM -0600, Stephen Warren wrote:
>> On 06/18/2013 03:29 AM, Christian Ruppert wrote:
>>> This patch adds the infrastructure required to register non-linear gpio
>>> ranges through gpiolib and the standard GPIO device tree bindings.
>>
>> I review this in case we decide to go with it anyway.
>>
>>> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
>>
>>> +In addition, named groups of pins can be mapped to pin groups of a given
>>> +pin controller:
>>> +
>>> +	gpio_pio_g: gpio-controller@1480 {
>>> +		#gpio-cells = <2>;
>>> +		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
>>> +		reg = <0x1480 0x18>;
>>> +		gpio-controller;
>>> +		gpio-ranges = <&pinctrl1 0 0 0>, <&pinctrl2 3 0 0>;
>>> +		gpio-ranges-group-names = "foo", "bar";
>>> +	};
>>> +
>>> +where,
>>> +   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.
>>> +
>>> +   The following value specifies the base GPIO offset of the pin range with
>>> +   respect to the GPIO controller's base. The remaining two values must be
>>> +   0 to indicate that a named pin group should be used for the respective
>>> +   range. The number of pins in the range is the number of pins in the pin
>>> +   group.
>>
>> It'd be good to re-write this section in a similar style to the cleanup
>> patches that I sent for the existing gpio-ranges documentation. That
>> makes the format description more of a raw syntax than English text.
> 
> can you please point me to some place where I can find those patches on
> the web?

The start of the thread is at:

https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/thread.html#35462

Patch 1/7 has already been applied. 2/7 and on are really the conversion.
