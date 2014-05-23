Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaEWPUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:20:50 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54182 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaEWPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <537F02CA.5070304@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
	<537EF50B.2010101@linaro.org>
	<CAPDyKFpTXrURM8OzNjO-RRfCFWGct4+_M4D8COdEurUhY46GWg@mail.gmail.com>
	<537F02CA.5070304@linaro.org>
Date: Fri, 23 May 2014 08:20:48 -0700
Message-ID: <CAJAp7OgkYg12C42yMqL+CJQG3hN2KeNs7L-ZO4b9JMAb_ofYog@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] Add Qualcomm SD Card Controller support
From: Bjorn Andersson <bjorn@kryo.se>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 1:11 AM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> On 23/05/14 08:50, Ulf Hansson wrote:
[...]
>> It seems like you had some CRC issues during read/write? Did you
>> manage to resolve that issue?
>
>
> Bjorn is using different SOC and board than the IFC6410 Am testing on, so
> its completely different setup.
> on IFC6410 we did lot of stress testing and no issues seen. so suspecting
> the issues are very specific to that board or the eMMC Bjorn is using.
>
> We are suspecting that the CRC issues are due to the fact that there is no
> code to manage regulators. My test setup uses dummy regulator, and the eMMC
> and external SD cards seems to be Ok with default voltages.
>
> Am not sure if thats the same with Bjorn's board.

I started off by using the same setup as you; relying on the boot leaving
everything in a working condition and using fixed-regulator; with that setup
I saw the CRC issues.

I then introduced my rpm and regulator driver and it didn't change anything
related to the CRC error behaviour.

I have verified that I have the right pinconf and the clocks seems to match
what we have with working codeaurora based SW.
One thing that I did notice is that we run our devices with
MMC_CAP_UHS_DDR50, while Qualcomm doesn't, but I have not been
able to introduce a change in behaviour by modifying the caps.

I do see the same problem both on 8960 and on 8064; although on 8064
it's much worse.


I will do some more debugging to see if I can find any further differences
in the two setups.

Regards,
Bjorn
