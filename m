Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaETIKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:10:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45061 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaETIKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:10:52 -0400
Message-ID: <537B0E08.50400@linaro.org>
Date: Tue, 20 May 2014 09:10:48 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: linux-mmc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com, linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/12] Add Qualcomm SD Card Controller support.
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org> <CAJAp7Oj5e8_zqNsHUxex8pd1zh4_sSzZMvp+67YSE39JDkoLAQ@mail.gmail.com>
In-Reply-To: <CAJAp7Oj5e8_zqNsHUxex8pd1zh4_sSzZMvp+67YSE39JDkoLAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Bjorn for testing this series.

On 19/05/14 23:08, Bjorn Andersson wrote:
> On Mon, Apr 21, 2014 at 2:43 PM,<srinivas.kandagatla@linaro.org>  wrote:
>> >From: Srinivas Kandagatla<srinivas.kandagatla@linaro.org>
> [snip]
>> >
>> >This patches are tested in PIO mode on IFC8064 board with both eMMC and
>> >external SD card. I would appreciate any feedback/suggestions on the overall
>> >approach.
> Hi Srini,
>
> I finally got around to give this series a spin on our APQ8064 based
> devices as well. I had a few reported CRC issues on our msm8960 based
> devices, but thinks seems functionally "ok".
>
> On APQ8064, the kernel finds the onboard eMMC and when mounting it I
> get the following:
>
> [    1.624118] mmc0: new high speed MMC card at address 0001
> [    1.627521] mmcblk0: mmc0:0001 MAG2GA 14.5 GiB
> [    1.632714] mmcblk0boot0: mmc0:0001 MAG2GA partition 1 2.00 MiB
> [    1.636989] mmcblk0boot1: mmc0:0001 MAG2GA partition 2 2.00 MiB
> [    1.637393] Freeing unused kernel memory: 332K (c09c6000 - c0a19000)
> [    1.663379] mmcblk0: response CRC error sending r/w cmd command,
>
> [    2.292914] mmcblk0: response CRC error sending r/w cmd command,
> card status 0xb00
> [    2.300985] mmcblk0: response CRC error sending r/w cmd command,
>
>
> Any suggestions of what I could do to help you debug this?
>

There might be couple of reasons why this might happen,

First is the regluators. currently the upstream kernel does not have 
support for regulators. So, does the eMMC on your board work perfectly 
fine with the default 2.7v?

secondly it could be eMMC vendor specific quirks.

I stress tested eMMC on IFC6410 and I did not hit any issues as you 
mentioned.

Are you aware of any such quirks specific to the eMMC on your board?

thanks,
srini

> Regards,
> Bjorn
