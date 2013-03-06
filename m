Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3CFXm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:42:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34131 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3CFXm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:42:56 -0500
Message-ID: <5137D47D.6030105@wwwdotorg.org>
Date: Wed, 06 Mar 2013 16:42:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: provide dummy cpu car ops
References: <1360853581-9756-1-git-send-email-pdeschrijver@nvidia.com> <643E69AA4436674C8F39DCC2C05F7638629CA50C97@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F7638629CA50C97@HQMAIL03.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 04:20 PM, Andrew Chew wrote:
>> Subject: [PATCH] clk: tegra: provide dummy cpu car ops
>>
>> tegra_boot_secondary() relies on some of the car ops. This means having an
>> uninitialized tegra_cpu_car_ops will lead to an early boot panic.
>> Providing a dummy struct avoids this and makes adding Tegra114 clock
>> support in a bisectable way a lot easier.
>>
>> --
>>
>> Stephen,
>>
>> Should this be a separate patch or should I make this part of new release of
>> the Tegra114 clock series?

I'm not sure if I answered this. Peter, I intend to apply this patch to
a branch right before the CCF, so there's no explicit need to include it
in the series, although if you do, that's fine.

>> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c index

>>  /* Global data of Tegra CPU CAR ops */
>> -struct tegra_cpu_car_ops *tegra_cpu_car_ops;
> 
> Sorry for bringing this up so late...
> Shouldn't the above be "struct tegra_cpu_car_ops tegra_cpu_car_ops;"?
> 
>> +static struct tegra_cpu_car_ops *dummy_car_ops; struct
>> +tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;

No, the value is used as a pointer in include/linux/clk/tegra.h, e.g.:

tegra_cpu_car_ops->wait_for_reset(cpu);

