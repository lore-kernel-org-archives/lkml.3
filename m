Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaIHIOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:14:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55344 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbaIHINy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:13:54 -0400
Message-ID: <540D653E.7070509@mm-sol.com>
Date: Mon, 08 Sep 2014 11:13:50 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
References: <1409919274-13419-1-git-send-email-svarbanov@mm-sol.com> <1409919274-13419-2-git-send-email-svarbanov@mm-sol.com> <3495079.hWGRuSPgx7@wuerfel>
In-Reply-To: <3495079.hWGRuSPgx7@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thank you for the comments!

On 09/05/2014 03:26 PM, Arnd Bergmann wrote:
> On Friday 05 September 2014 15:14:33 Stanimir Varbanov wrote:
>> +       VADC_CHAN(LR_MUX1_BAT_THERM, 0)                 /* 0x30 */
>> +       VADC_CHAN(LR_MUX2_BAT_ID, 0)
>> +       VADC_CHAN(LR_MUX3_XO_THERM, 0)
>> +       VADC_CHAN(LR_MUX4_AMUX_THM1, 0)
>> +       VADC_CHAN(LR_MUX5_AMUX_THM2,by you  0)
>> +       VADC_CHAN(LR_MUX6_AMUX_THM3, 0)
>> +       VADC_CHAN(LR_MUX7_HW_ID, 0)
>> +       VADC_CHAN(LR_MUX8_AMUX_THM4, 0)
>> +       VADC_CHAN(LR_MUX9_AMUX_THM5, 0)
>> +       VADC_CHAN(AMUX_PU1, 0)
>> +       VADC_CHAN(AMUX_PU2, 0)
>> +       VADC_CHAN(LR_MUX3_BUF_XO_THERM_BUF, 0)          /* 0x3c */
>> +
>> +       VADC_CHAN(LR_MUX1_PU1_BAT_THERM, 0)             /* 0x70 */
>> +       VADC_CHAN(LR_MUX2_PU1_BAT_ID, 0)
>> +       VADC_CHAN(LR_MUX3_PU1_XO_THERM, 0)
>> +       VADC_CHAN(LR_MUX4_PU1_AMUX_THM1, 0)
>> +       VADC_CHAN(LR_MUX5_PU1_AMUX_THM2, 0)
>> +       VADC_CHAN(LR_MUX6_PU1_AMUX_THM3, 0)
>> +       VADC_CHAN(LR_MUX7_PU1_AMUX_HW_ID, 0)
>> +       VADC_CHAN(LR_MUX8_PU1_AMUX_THM4, 0)
>> +       VADC_CHAN(LR_MUX9_PU1_AMUX_THM5, 0)
>> +       VADC_CHAN(LR_MUX10_PU1_AMUX_USB_ID, 0)          /* 0x79 */
>> +       VADC_CHAN(LR_MUX3_BUF_PU1_XO_THERM_BUF, 0)      /* 0x7c */
>>
> 
> These numbers all look hardware specific, so why put macros into the
> device tree rather than using them directly?

The idea was to use #defines in DT nodes when we need to overwrite the
adc channel parameters, see example in 2/2 how it will be used.

> 
> If you want to make up your own macro namespace, I would suggest
> using consecutive numbers and turning the above into
> 
> 	...
> 	[LR_MUX3_BUF_XO_THERM_BUF] = VADC_CHAN(0x3c, 0),
> 	[LR_MUX1_PU1_BAT_THERM]    = VADC_CHAN(0x70, 0),
> 	[LR_MUX1_PU1_BAT_ID]       = VADC_CHAN(0x71, 0),
> 	...
> 
> but I don't see that really improving the DT, since you then
> need to look up the values in the header rather than the data sheet.

I will see how can I make this elegantly by using IIO infrastructure better.

regards,
Stan
