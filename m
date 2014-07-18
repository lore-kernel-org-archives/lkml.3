Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030420AbaGRQL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:11:57 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48382 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965219AbaGRQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:11:55 -0400
MIME-Version: 1.0
In-Reply-To: <32226622.5gSmvBRKvZ@wuerfel>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
	<6917971.QKItNU3coA@wuerfel>
	<CAGTfZH1EHiTpo2Abua=+kDfNoOQx+ydPHU51=+qW8mgCL4Lwvg@mail.gmail.com>
	<32226622.5gSmvBRKvZ@wuerfel>
Date: Sat, 19 Jul 2014 01:11:53 +0900
Message-ID: <CAGTfZH3vz9MLN+1fPM22zKE64oMNDgcib3is0nfzZhhLkmdNvw@mail.gmail.com>
Subject: Re: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        galak@codeaurora.org, naveen krishna <ch.naveen@samsung.com>,
        jic23@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 12:23 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 19 July 2014 00:15:35 Chanwoo Choi wrote:
>> On Fri, Jul 18, 2014 at 8:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Friday 18 July 2014 19:00:48 Chanwoo Choi wrote:
>> >> On 07/18/2014 06:47 PM, Arnd Bergmann wrote:
>> >> >
>> >> > Further, why is it called "sclk_adc" rather than just "sclk"?
>> >>
>> >> The sclk means 'special clock' in Exynos TRM. Exynos SoC has varisou sclk clocks.
>> >> 'sclk_adc' is only used for ADC IP.
>> >
>> > But that sounds like sclk_adc is the name of the global name
>> > of the clock signal coming out of the clock controller.
>> >
>> > I still think it would be best to name it 'sclk' as the input
>> > for the adc. It shouldn't rely on a particular name of the
>> > clock controller.
>>
>> I think 'sclk' is too common name. 'sclk' don't include specific device name.
>> As I know, usual clock name includes the name of IP or includes the
>> specific meaning for each IP.
>
> No, normally it does not include the name of the IP, that's my whole point.
> Including the name of the IP is completely pointless because that is
> implied by the fact that it's being used by that particular IP.
>
> Ideally you would find the data sheet for the ADC IP block and figure
> out what this clock is used for, then find the right name for that.

I mentioned the meaning of clocks ('adc', 'sclk_adc') as following in
patch description.
But, you think that need the more proper name instead of 'sclk_adc' to mean the
correct operation of 'sclk_adc'. I'll check once again the meaning of
'sclk_adc' in data sheet
and renaming it.

  Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
  - 'adc' clock: bus clock for ADC

  Exynos3250 has additional 'sclk_adc' clock as following:
  - 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC

> In a lot of cases, we are actually better off not naming the clocks
> at all but simply enumerating them if nobody knows what they are good
> for. In that case, you would simply have the first clock and the second
> clock of the ADC part and enable them both.

Thanks for your  review.
Chanwoo Choi
