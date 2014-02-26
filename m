Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaBZHlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:41:37 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:62472 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaBZHlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:41:35 -0500
MIME-Version: 1.0
In-Reply-To: <1393375569-21751-1-git-send-email-sre@debian.org>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Wed, 26 Feb 2014 08:40:54 +0100
Message-ID: <CAHYPw2EeEnDn2FUYSMWbywprmhJmcRRyaTPn1YZK0xPvuiJQFw@mail.gmail.com>
Subject: Re: [PATCHv1 0/2] Convert rx51-battery to IIO API and add DT support
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Marek Belisko <marek@goldelico.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-iio@vger.kernel.org,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

2014-02-26 1:46 GMT+01:00 Sebastian Reichel <sre@debian.org>:
> Hi,
>
> This is PATCHv1 for converting rx51-battery to the IIO API
> and adding DT support. The patchset compiles and has been
> tested on my Nokia N900. It depends on another patchset
> converting twl4030-madc to the IIO API:
>
> https://lkml.org/lkml/2014/2/25/627
>
> -- Sebastian
>
> Sebastian Reichel (2):
>   rx51_battery: convert to iio consumer
>   Documentation: DT: Document rx51-battery binding
>
>  .../devicetree/bindings/power/rx51-battery.txt     | 25 ++++++++
>  drivers/power/rx51_battery.c                       | 68 ++++++++++++++--------
>  2 files changed, 70 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power/rx51-battery.txt
>
> --
> 1.8.5.3
>

Thanks for patch!

I would like to ask other kernel developers what do you think about
moving ADC channel numbers from rx51_battery.ko driver code to DT.
Driver rx51_battery.ko is platform specific for Nokia RX-51 (N900) so
it is usefull only for this one device.

Before this patch all driver data (look-up tables, adc channel
numbers, etc...) were in driver code. Now after this patch adc channel
numbers were moved to DT. What do you think? It is better to have all
data in one place (driver code) or some in DT and some in driver code?

For me it does not make sense to move these numbers to DT, because
driver is rx51 device specific and chaning it in DT does not make
sense. And I think it is better to have add driver data in one place
and not in two...

Sebastian already wrote me that this is normal to have numbers in DT
and other code in driver. But I think that driver which can be used
only in one device (so specified only in one DT file) does not need to
have configuration (via DT or board files).

Or do you think that driver specified only for one device needs to
have ADC numbers configuration via DT?

-- 
Pali Rohár
pali.rohar@gmail.com
