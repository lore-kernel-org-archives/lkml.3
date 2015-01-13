Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbbAMP7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:59:38 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48007 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbbAMP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:59:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAJAp7Oi0AyLxy1KFpZ-Cz1-ts9Lh2UaxP3+e6n3EyQjVaEfoXg@mail.gmail.com>
References: <54584260.8030602@nvidia.com>
	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
	<545895B2.2000101@nvidia.com>
	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>
	<CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com>
	<CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
	<CAJAp7Oh+ziadeEDWsus_k_2w33vPJxGGcGZyMNQkpLemf7SAhg@mail.gmail.com>
	<CAJAp7OhWKoAoZfq+zWspLnqUkoJb3izMD41Vyfn0AW4Jni8HAQ@mail.gmail.com>
	<CAD7vxxLe5COSrsnVZ2G_uhtUXfjFnDA45HSG2dNT1LrxcyFcQw@mail.gmail.com>
	<CAJAp7OhAP-rDM2zyo0Yr0-7erUp4ewKJ+tC=vyU-YMP_MzXJbA@mail.gmail.com>
	<CAD7vxxJy2sE1os+ipJZV7_GvEyhu8cE-0QLBS5SVHUqfjkYBwQ@mail.gmail.com>
	<CAJAp7Oi0AyLxy1KFpZ-Cz1-ts9Lh2UaxP3+e6n3EyQjVaEfoXg@mail.gmail.com>
Date: Tue, 13 Jan 2015 07:59:33 -0800
Message-ID: <CAD7vxxKYAkAN3aQenEg+6=h2KTEgXxi3h1CAWR7Na7NAZiuM=A@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Tim Kryger <tim.kryger@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
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

On Mon, Jan 5, 2015 at 11:52 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Sun, Dec 21, 2014 at 7:01 PM, Tim Kryger <tim.kryger@gmail.com> wrote:
>> On Wed, Dec 17, 2014 at 11:57 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> [..]
>>> Non-the-less, feel free to propose a patch and I will give it a test.
>>
>> Lets start with the simplest change first.  Please give this a try and
>> let me know what you think.
>>
>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>> index ada1a3e..59a328a 100644
>> --- a/drivers/mmc/host/sdhci.c
>> +++ b/drivers/mmc/host/sdhci.c
>> @@ -1239,6 +1239,12 @@ static void sdhci_set_power(struct sdhci_host
>> *host, unsigned char mode,
>>                 spin_unlock_irq(&host->lock);
>>                 mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, vdd);
>>                 spin_lock_irq(&host->lock);
>> +
>> +               if (mode != MMC_POWER_OFF)
>> +                       sdhci_writeb(host, SDHCI_POWER_ON, SDHCI_POWER_CONTROL);
>> +               else
>> +                       sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
>> +
>>                 return;
>>         }
>>
>>
>> Thanks again for your help in getting to the bottom of this.
>
> Sorry for the delay, but
>
> Tested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>
> Regards,
> Bjorn

Thanks.  I really appreciate your help.

-Tim
