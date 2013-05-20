Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3ETDIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:08:23 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:22680
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755086Ab3ETDIW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:08:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I103dK542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fhbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: RE: [PATCH v3] clocksource: add MVF600 pit timer support
Thread-Topic: [PATCH v3] clocksource: add MVF600 pit timer support
Thread-Index: AQHOUgLKkKGGf9R2n0eRY3h+AwTdH5kNXziAgAAGZuA=
Date: Mon, 20 May 2013 03:08:54 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E851CB223@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1368684924-1560-1-git-send-email-b35083@freescale.com>
 <20130520022747.GA25113@S2101-09.ap.freescale.net>
In-Reply-To: <20130520022747.GA25113@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Shawn Guo [mailto:shawn.guo@linaro.org]
>Sent: Monday, May 20, 2013 10:28 AM
>To: Lu Jingchang-B35083
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>john.stultz@linaro.org; tglx@linutronix.de; s.hauer@pengutronix.de
>Subject: Re: [PATCH v3] clocksource: add MVF600 pit timer support
>
>On Thu, May 16, 2013 at 02:15:24PM +0800, Jingchang Lu wrote:
>> Add Freescale Vybrid MVF600 period interrupt timer support.
>>
>> Signed-off-by: Jingchang Lu <b35083@freescale.com>
>> ---
>> v3:
>>   move the pit driver to drivers/clocksource.
>>
>>  drivers/clocksource/Kconfig            |   5 +
>>  drivers/clocksource/Makefile           |   1 +
>>  drivers/clocksource/mvf600_pit_timer.c | 224
>> +++++++++++++++++++++++++++++++++
>
>This is a driver for PIT, a timer IP block found on mvf family.  Even
>though we prefer to use particular SoC name to specify the compatibility
>and version of the block, all the versions of the IP block should be
>ideally supported by single PIT driver.  This is just like we have drivers
>spi-imx and i2c-imx support all SPI and I2C controllers found on IMX SoCs.
>That said, I suggest you use family name "mvf" to name the driver, Kconfig
>symbol etc. and use "mvf600" only in compatible string.
>
[Lu Jingchang-B35083] 
  I am not sure MVF5xx and MVF7xx have the same PIT block, if you have information that it is the same on other Vybrid SoCs, it is ok to change the driver name to mvf. Thanks!
>>  3 files changed, 230 insertions(+)
>> +
>> +	/* choose PIT2 as clocksource, PIT3 as clockevent dev */
>
>Reading the comment, I have a natural question - what PIT0 and PIT1 are
>used for?
>
[Lu Jingchang-B35083] 
PIT0 and PIT1 can be chained to build a 64-bit timer, so PIT2 and PIT3 are selected as the clocksource and clockevent device, and leave PIT0 and PIT1 unused for anyone else who needs them. Thanks!
>


