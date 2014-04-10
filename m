Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbaDJIWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:22:38 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:34536 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbaDJIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:22:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKq+D+c-qznP5aE3uyXf_YXyYzvoKRONAY7eXBkWcvqsw@mail.gmail.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com>
	<1397072736-10793-5-git-send-email-matthias.bgg@gmail.com>
	<CAL_JsqKq+D+c-qznP5aE3uyXf_YXyYzvoKRONAY7eXBkWcvqsw@mail.gmail.com>
Date: Thu, 10 Apr 2014 10:22:34 +0200
Message-ID: <CABuKBeK9QE8ZGx1AKa9Cr9GLdHDKW-+NBirWs=uekqKxMP65EQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm: mediatek: Add earlyprintk support for MT6589
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Jonathan Cameron <jic23@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Silvio F <silvio.fricke@gmail.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko.stuebner@bq.com>,
        Olof Johansson <olof@lixom.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-09 23:39 GMT+02:00 Rob Herring <robherring2@gmail.com>:
> On Wed, Apr 9, 2014 at 2:45 PM, Matthias Brugger <matthias.bgg@gmail.com> wrote:
>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>> ---
>>  arch/arm/Kconfig.debug            |   49 +++++++++++++++++++++++++++++++++++--
>>  arch/arm/include/debug/mediatek.S |   38 ++++++++++++++++++++++++++++
>>  2 files changed, 85 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/arm/include/debug/mediatek.S
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index 4a2fc0b..dc51495 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -797,6 +797,38 @@ choice
>>                   Say Y here if you want kernel low-level debugging support
>>                   on Ux500 based platforms.
>>
>> +       config DEBUG_MTK6589_UART0
>> +               depends on ARCH_MEDIATEK
>> +               bool "Mediatek mt6589 UART0"
>> +               select DEBUG_UART_MEDIATEK
>> +               help
>> +                 Say Y here if you want kernel low-level debugging support
>> +                 on Mediatek mt6589 based platforms.
>> +
>> +       config DEBUG_MTK6589_UART1
>> +               depends on ARCH_MEDIATEK
>> +               bool "Mediatek mt6589 UART1"
>> +               select DEBUG_UART_MEDIATEK
>> +               help
>> +                 Say Y here if you want kernel low-level debugging support
>> +                 on Mediatek mt6589 based platforms.
>> +
>> +       config DEBUG_MTK6589_UART2
>> +               depends on ARCH_MEDIATEK
>> +               bool "Mediatek mt6589 UART2"
>> +               select DEBUG_UART_MEDIATEK
>> +               help
>> +                 Say Y here if you want kernel low-level debugging support
>> +                 on Mediatek mt6589 based platforms.
>> +
>> +       config DEBUG_MTK6589_UART3
>> +               depends on ARCH_MEDIATEK
>> +               bool "Mediatek mt6589 UART3"
>> +               select DEBUG_UART_MEDIATEK
>> +               help
>> +                 Say Y here if you want kernel low-level debugging support
>> +                 on Mediatek mt6589 based platforms.
>> +
>
> Do you really need all uarts defined? Only define what you have boards using.
>
> Also, you have no uarts defined in your dts. Please add them there
> (and any necessary serial driver) before adding debug functionality.
> Otherwise, you can't actually boot a multi-platform kernel with this
> series.

Up to now, there no serial driver exists. Should I skip this patch and
re-submit it when the serial driver is integrated?


-- 
motzblog.wordpress.com
