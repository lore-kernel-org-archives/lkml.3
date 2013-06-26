Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FZNNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:13:20 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39980 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3FZNNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:13:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=otbQ71TXn=-f3WddNoyvP6NmTHCtSPqwDwkYr2Y7micqRTQ@mail.gmail.com>
References: <1372159970-6361-1-git-send-email-ruslan.bilovol@ti.com>
	<51C9867C.80206@ti.com>
	<51C99056.5090104@ti.com>
	<CAB=otbQ71TXn=-f3WddNoyvP6NmTHCtSPqwDwkYr2Y7micqRTQ@mail.gmail.com>
Date: Wed, 26 Jun 2013 08:13:17 -0500
X-Google-Sender-Auth: ksmyd1GYmUiKuqPhc_w2_oCvcQE
Message-ID: <CAGo_u6ohf86j3VouQZKkkf6Gv3x-wJKfNN=TALSRCgvh0NBEtg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
From: Nishanth Menon <nm@ti.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, benoit.cousson@linaro.org,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:03 AM, Ruslan Bilovol <ruslan.bilovol@ti.com> wrote:
> Hi Nishanth,
>
> On Tue, Jun 25, 2013 at 3:43 PM, Nishanth Menon <nm@ti.com> wrote:
>> On 06/25/2013 07:01 AM, Nishanth Menon wrote:
>>>
>>> On 06/25/2013 06:32 AM, Ruslan Bilovol wrote:
>>>>
>>>> The OMAP4 Blaze Tablet is TI OMAP4 processor-based
>>>> development platform in a tablet formfactor.
>>>> The platform contains many of the features found in
>>>> present-day handsets (such as audio, video, wireless
>>>> functions and user interfaces) and in addition
>>>> contains features for software development and test.
>>>>
>>>> This patch adds initial support for the OMAP4 Blaze
>>>> Tablet development platform. Additional functionality
>>>> depends on different drivers and code modifications that
>>>> are not upstreamed yet or do not support DT yet, so will
>>>> be added later.--
>>>
>>>
>>> http://svtronics.com/omap/sevm4460,blaze,omap might help too :)
>
> Yes, forgot to add this information from cover-letter from previous
> version of patch :)

;) - link was wrong!
http://svtronics.com/omap?product_id=15 is more like it -> Blaze
tablet by default comes in 4460/4470 variants. I suggest introducing
4470 variant here.
I am aware of the SOM compatibility and ability to support 4430 SOM on
tablet as well, but to keep tablet alive and reduce scope of testing,
keeping just 4470 in place might be a good choice.

just my 2 cents, no strong feelings towards either. :)

>
>>> [...]
>>>>
>>>> +
>>>> +#include "twl6030.dtsi"
>>>> +
>>>
>>> Might be good to see the TWL interrupt pin information made available as
>>> well?
>>
>> Allow me to rephrase a comment a little bit more :)
>> Similar to twl4030_omap3.dtsi, we could introduce twl6030_omap4.dtsi. this
>> could contain the common pins used for 6030.
>>  &omap4_pmx_wkup {
>>          pinctrl-names = "default";
>>          pinctrl-0 = <
>>                          &twl6030_wkup_pins
>>          >;
>>
>>          twl6030_wkup_pins: pinmux_twl6030_wkup_pins {
>>                  pinctrl-single,pins = <
>>                          0x14 (PIN_OUTPUT | MUX_MODE2)
>>                  >;
>>          };
>>  };
>>
>>         twl6030_pins: pinmux_twl6030_pins {
>>                 pinctrl-single,pins = <
>>                         0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)
>> /* sys_nirq1.sys_nirq1 */
>>                 >;
>>         };
>>
>> which is now already duplicated in 2 places (SDP and Panda), and in this
>> patch duplicated again.
>
> Agree, I'm planning to do this later as part of moving common things into
> some System-On-Module(SOM)-specific files, as discussed previously
> here https://patchwork.kernel.org/patch/2118371/
>
I dont think I was mentioning about that - I just would really like to
avoid duplication of 6030 information all over the place. if we can
avoid it, lets start consolidating.
Regards,
Nishanth Menon
