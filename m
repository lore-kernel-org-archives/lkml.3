Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaLPSTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:19:03 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:47796 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaLPSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:19:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAJAp7Oh+ziadeEDWsus_k_2w33vPJxGGcGZyMNQkpLemf7SAhg@mail.gmail.com>
References: <54584260.8030602@nvidia.com>
	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
	<545895B2.2000101@nvidia.com>
	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>
	<CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com>
	<CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
	<CAJAp7Oh+ziadeEDWsus_k_2w33vPJxGGcGZyMNQkpLemf7SAhg@mail.gmail.com>
Date: Tue, 16 Dec 2014 10:18:59 -0800
Message-ID: <CAJAp7OhWKoAoZfq+zWspLnqUkoJb3izMD41Vyfn0AW4Jni8HAQ@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Bjorn Andersson <bjorn@kryo.se>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:27 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Sun, Dec 14, 2014 at 8:48 PM, Tim Kryger <tim.kryger@gmail.com> wrote:
>> On Sat, Dec 13, 2014 at 11:22 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> [..]
>>> Or simply; what is vmmc (in the code) supposed to represent?
>>
>> Hi Bjorn,
>>
>> VMMC is the supply that delivers power out to the SD card itself (aka VDD).
>>
>> It is not the internal power rail/power domain of the host controller
>> within the SoC.
>>
>
> Thanks for you answer Tim, I'll write up a patch for the Qualcomm
> driver that add the possibility of specifying an internal supply for
> the devices where that uses that.
>
> My only concern is that for any standard compliant sdhci driver we're
> supposed to have a info printout that vmmc was not found (but vqmmc is
> there). But I guess that's a matter of proper documentation and hoping
> people don't pay too much attention to it?
>

Sorry, this is wrong.

We are routing the regulators straight to vdd of the memory and should
hence use vmmc to specify this. However unless I actually program 0x29
in the Qualcomm sdhci block I get no responses from the card.

Which I believe is correct behavior as the SDHC specification [1] says
the following about BIT(0) of 0x29:

"If this bit is cleared, the Host Controller shall immediately stop
driving CMD and DAT[3:0] (tri-state) and drive SDCLK to low level".


So I think 52221610d is indeed incorrect.

[1] https://www.sdcard.org/downloads/pls/simplified_specs/archive/partA2_300.pdf

Regards,
Bjorn
