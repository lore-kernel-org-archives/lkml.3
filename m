Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaGKP3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:29:11 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16103 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaGKP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:29:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 08:21:58 -0700
Message-ID: <53C002BE.90805@nvidia.com>
Date: Fri, 11 Jul 2014 18:29:02 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com> <1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com> <CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com> <20140711091207.GY23218@tbergstrom-lnx.Nvidia.com> <20140711145735.GB6523@ulmo> <53BFFEAD.7000405@nvidia.com> <20140711151501.GA25810@ulmo>
In-Reply-To: <20140711151501.GA25810@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/14 18:15, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Fri, Jul 11, 2014 at 06:11:41PM +0300, Tuomas Tynkkynen wrote:
>> On 11/07/14 17:57, Thierry Reding wrote:
>>
>>>> I don't think that's going to work? The voltage scaling is handled in hw.
>>>
>>> Do we have to handle it in hardware or can we opt to do it in software,
>>> too?
>>>
>>
>> With the PLLX, voltage scaling is done entirely in SW. With the DFLL,
>> it's possible to stay in open-loop mode and do it in SW, but there's
>> not much point in that.
>
> It's kind of ugly how we need to pass the address of the PMU and the
> offset of the voltage control register to the DFLL which will then
> initiate I2C transactions itself. I'm wondering if that plays well with
> the I2C traffic originating from within the kernel.
>

On the hardware level, the two I2C controllers sharing the same pins
have knowledge of each other and won't start transmitting if the bus
is busy (something different from the usual I2C arbitration, that is).
I guess on the kernel side there could be a problem if the voltage 
register is marked cached in the PMIC driver's regmap.

-- 
nvpublic
