Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3FYMnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:43:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34288 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3FYMnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:43:11 -0400
Message-ID: <51C99056.5090104@ti.com>
Date: Tue, 25 Jun 2013 07:43:02 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <benoit.cousson@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
References: <1372159970-6361-1-git-send-email-ruslan.bilovol@ti.com> <51C9867C.80206@ti.com>
In-Reply-To: <51C9867C.80206@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 07:01 AM, Nishanth Menon wrote:
> On 06/25/2013 06:32 AM, Ruslan Bilovol wrote:
>> The OMAP4 Blaze Tablet is TI OMAP4 processor-based
>> development platform in a tablet formfactor.
>> The platform contains many of the features found in
>> present-day handsets (such as audio, video, wireless
>> functions and user interfaces) and in addition
>> contains features for software development and test.
>>
>> This patch adds initial support for the OMAP4 Blaze
>> Tablet development platform. Additional functionality
>> depends on different drivers and code modifications that
>> are not upstreamed yet or do not support DT yet, so will
>> be added later.
>
> http://svtronics.com/omap/sevm4460,blaze,omap might help too :)
> [...]
>> +
>> +#include "twl6030.dtsi"
>> +
> Might be good to see the TWL interrupt pin information made available as
> well?
Allow me to rephrase a comment a little bit more :)
Similar to twl4030_omap3.dtsi, we could introduce twl6030_omap4.dtsi. 
this could contain the common pins used for 6030.
  &omap4_pmx_wkup {
          pinctrl-names = "default";
          pinctrl-0 = <
                          &twl6030_wkup_pins
          >;

          twl6030_wkup_pins: pinmux_twl6030_wkup_pins { 

                  pinctrl-single,pins = <
                          0x14 (PIN_OUTPUT | MUX_MODE2)
                  >;
          };
  };

	twl6030_pins: pinmux_twl6030_pins {
		pinctrl-single,pins = <
			0x15e (WAKEUP_EN | PIN_INPUT_PULLUP | MUX_MODE0)	/* 
sys_nirq1.sys_nirq1 */
		>;
	};

which is now already duplicated in 2 places (SDP and Panda), and in this 
patch duplicated again.

just my 2 cents :(
---
Regards,
Nishanth Menon
