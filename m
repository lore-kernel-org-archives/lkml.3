Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbaIRVOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:14:23 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:48525 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbaIRVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <1411024883.27455.11.camel@debian-rtk5880>
References: <1410485999-10939-1-git-send-email-micky_ching@realsil.com.cn>
	<CAPDyKFqcbK9OuQXbegignwiS7rz3L8resQ7Jfc8WvqXEKTcWVA@mail.gmail.com>
	<54195036.2010409@realsil.com.cn>
	<CAPDyKFrbMaDxU3VkhMO63+tLRMipKPqGvYC5cT2PTeVU1CTTQg@mail.gmail.com>
	<1411024883.27455.11.camel@debian-rtk5880>
Date: Thu, 18 Sep 2014 23:14:20 +0200
Message-ID: <CAPDyKFqokjwerEC+6A=2h4cPH29rnX0tyW=2=KQX2rSE=SEKHw@mail.gmail.com>
Subject: Re: [PATCH] mmc: rtsx: add card power off during probe
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger Tseng <rogerable@realtek.com>
Cc: micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

>>
>> In that case, don't forget to enable MMC_CAP2_FULL_PWR_CYCLE.
>>
>> >
>> > if MMC_CAP2_NO_PRESCAN_POWERUP enable, will call mmc_power_off() at start,
>> > then it will check ios.power_mode, but the state is MMC_POWER_OFF and just
>> > return.
>>
>> Uhh, that's right! So, I wonder why we invokes mmc_power_off() from
>> that path at all.
>>
>> Hmm, I think we should change the behavior in mmc_start_host(), like below:
>> 1) Add a "MMC_POWER_UNDEFINED" state which is what the power state
>> should be assigned to at allocation.
>> 2 ) From mmc_start_host(), invoke mmc_power_off() when
>> MMC_CAP2_NO_PRESCAN_POWERUP and MMC_CAP2_FULL_PWR_CYCLE is set.
>>
>> Would that work?
> Yes. I have confirmed this by following changes. The MMC_POWER_UNDEFINED
> designation in mmc_start_host() will eventually cause a power-off
> operation.
>
> But I wonder if we need to additionally check MMC_CAP2_FULL_PWR_CYCLE
> before calling mmc_power_off()?

The intent from my side was to keep the current behaviour for those
that already used MMC_CAP2_NO_PRESCAN_POWERUP, but it's s not a big
deal.

So, let's try your proposal, thus don't check MMC_CAP2_FULL_PWR_CYCLE.

Can you repost new version of your patches and please split them up on
core and host separately.

Kind regards
Uffe
