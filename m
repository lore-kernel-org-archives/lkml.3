Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3HENFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:05:02 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17487 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3HENFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:05:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 05 Aug 2013 06:03:22 -0700
Message-ID: <51FFA2F8.6040200@nvidia.com>
Date: Mon, 5 Aug 2013 16:04:56 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra30: Don't wait for PLL_U lock bit
References: <1375292551-7933-1-git-send-email-ttynkkynen@nvidia.com> <1375292551-7933-2-git-send-email-ttynkkynen@nvidia.com> <51F97BEA.7040006@wwwdotorg.org> <51FF487F.6000007@nvidia.com>
In-Reply-To: <51FF487F.6000007@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 09:38 AM, Prashant Gaikwad wrote:
> On Thursday 01 August 2013 02:34 AM, Stephen Warren wrote:
>> On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
>>> The lock bit on PLL_U does not seem to be working correctly and
>>> sometimes never gets set when waiting for the PLL to come up.
>>> Remove the TEGRA_PLL_USE_LOCK flag to use a constant delay.
>> Peter, Prashant,
>>
>> I think you said that the lock bits should work on Tegra30 (albeit they
>> don't on Tegra20)? Can you remind me if the do/don't?
>>
>> If Peter and Prashant are OK with this patch, feel free to take my ack.
> 
> Hi Tuomas,
> 
> Sorry for the delayed response. Please make sure that avdd_usb_pll 
> regulator is enabled before enabling PLLU and utmip parameters are 
> configured properly.

As far as I can see, avdd_usb_pll is connected to the vio_reg regulator on Cardhu,
which is marked as regulator-always-on. And the same regulator is connected to
eg. VDDIO_UART on the chip, so I presume almost nothing would work if that regulator
would not be on...

> If this this regulator is not enabled then you will get this kind of 
> timeout when enabling PLLU.
> 
> Thanks,
> Prashant
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

