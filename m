Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaHEO0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:26:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23339 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaHEO0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:26:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-7e-53e0e98dd720
Message-id: <53E0E98F.5020706@samsung.com>
Date: Tue, 05 Aug 2014 16:26:23 +0200
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
References: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
 <53E0E420.8060207@linaro.org>
In-reply-to: <53E0E420.8060207@linaro.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xa7q9Lx8EG3z7y2qxccZ6Vot5n2Ut
	Xr8wtOhdcJXN4mzTG3aL94eeMVtsenyN1eLyrjlsFp97jzBazDi/j8nizOlLrBYn//QyWqyf
	8ZrFYuNXDwc+jzvX9rB5bF5S73H732Nmjy1X21k8+rasYvT4vEkugC2KyyYlNSezLLVI3y6B
	K+Pb3cdsBQc5K75s/s7cwHiIvYuRk0NCwETi4uUbbBC2mMSFe+uBbC4OIYGljBLP/mxkh3A+
	M0rcv7oQrINXQEti17rLYB0sAqoSnXsvgMXZBIwlNi9fAhYXFQiTePbrIBNEvaDEj8n3WEAG
	iQj0MEr0d3SAFTELfGaSaJwrAGILC2RIPPp3gQXEFgKyN9x+zApicwIt27ZsDVS9mcSXl4dZ
	IWx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREjFf
	djAuPmZ1iFGAg1GJh9fg9N1gIdbEsuLK3EOMEhzMSiK87LcfBAvxpiRWVqUW5ccXleakFh9i
	ZOLglGpgDP8dkvTPutN8yzmOr99Z9jY2nddg1I+8nRk84UdQmcKtKOED7GZRLo96tOSNuoKE
	djxv8X/KeHDPTZEtDQrvWbQMJs8/28Nvm9Lvuqy3+rpbikzpsbksIR2VO/0+LTc4xHCr2qHz
	E3vIvP9pZYdOXli9yf1bwI3nD3/Y9vb7zl93SuTrKxNzJZbijERDLeai4kQATeUykXYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.2014 16:03, Daniel Lezcano wrote:
> On 08/05/2014 03:34 PM, Bartlomiej Zolnierkiewicz wrote:
>> Hi,
>>
>> This patch series adds support for AFTR idle mode on boards with
>> secure firmware enabled and allows EXYNOS cpuidle driver usage on
>> Exynos4x12 SoCs.
>>
>> It has been tested on Trats2 board (using Exynos4412 SoC with secure
>> firmware enabled) on which AFTR mode reduces power consumption by ~12%
>> when EXYNOS cpuidle driver is enabled (in both cases the default
>> exynos_defconfig config is used and CPU1-3 are offlined).
>
> As a sidenote:
>
> On my odroid-U2:
>   * 4 cpus online -> 130 mA
>   * 3 cpus online -> 164 mA
>   * 2 cpus online -> 160 mA
>   * 1 cpu online  -> 157 mA
>
> So were are consuming more when there are unplugged cpu ... any ideas ?

On which tree are you testing? Current next has ARMCLK down feature 
enabled. ARMCLK down may stop working after hotunplugging CPU:
http://www.spinics.net/lists/arm-kernel/msg352890.html

That was observed especially on Exynos4212 where ARMCLK down stops 
working permanently. On Trats2 (Exynos4412) the clock down stopped only 
a for short period after disabling CPU.

Best regards,
Krzysztof



