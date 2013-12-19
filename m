Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab3LSF03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 00:26:29 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1624 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3LSF01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 00:26:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Dec 2013 21:27:42 -0800
Message-ID: <52B28397.5010808@nvidia.com>
Date: Thu, 19 Dec 2013 13:26:47 +0800
From: bilhuang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>	<1386229462-3474-3-git-send-email-bilhuang@nvidia.com>	<CAKohponns4B+BPPum3EN6EuXx6U+6MzOa50gMdR1BNBtxMNf0Q@mail.gmail.com>	<52B02D04.4050905@nvidia.com>	<CAKohpom0n8P8goQnsgBnWJwyqCVv_FRX3xKvO1yFW0VUMpMW8w@mail.gmail.com>	<52B187F5.7020105@nvidia.com> <CAKohpokwhYC4FGnhpZPOGuJ2AM_7vygNk+3S+VpA_eXAexQX7g@mail.gmail.com>
In-Reply-To: <CAKohpokwhYC4FGnhpZPOGuJ2AM_7vygNk+3S+VpA_eXAexQX7g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 10:39 PM, Viresh Kumar wrote:
> On 18 December 2013 17:03, bilhuang <bilhuang@nvidia.com> wrote:
>> cpufreq-cpu0 driver will call regulator_set_voltage_tol() directly according
>> to the pre-defined OPP freq/volt pairs, the regulator drivers could be
>> shared by other SoC so is not suitable to handle this, or do I
>> misunderstand?
>
> In case regulator's driver is shared, then you can probably add another
> virtual regulator for CPU which would have the special code you want.
>
I'm not sure virtual regulator for CPU is a good idea, in addition to 
that, we don't have a single SoC OPP table, we need several which are 
speedo-id and process-id dependant, but generic cpufreq-cpu0 is assuming 
there is only one statically, for some SoC the frequency table is not 
fixed, they are created at runtime combining our fast and slow CPU 
frequency table and dvfs table. So I'm really not sure is it worth 
adding so many tweaks in order to use the generic cpufreq-cpu0 driver.
