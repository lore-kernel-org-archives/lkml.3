Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaEVKet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:34:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54776 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaEVKer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:34:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-98-537dd2c35d92
Message-id: <537DD2C0.4060802@samsung.com>
Date: Thu, 22 May 2014 12:34:40 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
 <1400604211-9447-4-git-send-email-t.figa@samsung.com>
 <537D8788.8030904@linaro.org>
In-reply-to: <537D8788.8030904@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xK7qHL9UGG+yfym4x9eETNov5R86x
	WvQuuMpmsenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2SyeDrhIpvFoq1f2C2mLDrMatG69wi7
	xapdfxgt2v/uZXPg81gzbw2jx85Zd9k9Nq3qZPO4c20Pm8fmJfUefVtWMXp83iQXwB7FZZOS
	mpNZllqkb5fAlbGyvZG54DtPRdttswbGWVxdjBwcEgImEmdPeHQxcgKZYhIX7q1nA7GFBJYy
	SjxfUNzFyAVkf2aUONjZwg6S4BXQkvhz6w1YEYuAqsS9DRvB4mwCahKfGx6BxfmBatY0XWcB
	mS8qECHx+IIQRKugxI/J91hAbBEBf4nT984zg8xnFjjBLPH15WtGkISwQKTErYvPWSAWz2SU
	+HbtOliCE2johOtdrCA2s4COxP7WaWwQtrzE5jVvmScwCs5CsmQWkrJZSMoWMDKvYhRNLU0u
	KE5KzzXUK07MLS7NS9dLzs/dxAiJqS87GBcfszrEKMDBqMTDK3C1OliINbGsuDL3EKMEB7OS
	CO++M7XBQrwpiZVVqUX58UWlOanFhxiZODilGhi3vGl7I69i0LF44t6NFj4VDCf8bTU9Fgpd
	bWzOZOm9r3K2s+OEyFR5vkmcO+VmPtuRbWo5V9P0wimdU+2POh+x78ufwGL6R/OnfNGVfNkZ
	ZazCFuIHV/w50tj4p7s8efY8/7My67KfLuASsrjrdvLQk6oKg6ro47yZupfFQlo5JhsvF386
	q0CJpTgj0VCLuag4EQB0vH2zhwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2014 07:13, Tushar Behera wrote:
> On 05/20/2014 10:13 PM, Tomasz Figa wrote:
>> This patch introduces a driver that handles configuration of CLKOUT pin
>> of Exynos SoCs that can be used to output certain clocks from inside of
>> the SoC to a dedicated output pin.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>>  drivers/clk/samsung/Makefile                       |   1 +
>>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++++
>>  3 files changed, 184 insertions(+)
>>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
>>
> 
> [ ... ]
> 
>> +	clkout->clk_table[0] = clk_register_composite(NULL, "clkout",
>> +				parent_names, parent_count, &clkout->mux.hw,
>> +				&clk_mux_ops, NULL, NULL, &clkout->gate.hw,
>> +				&clk_gate_ops, CLK_SET_RATE_PARENT
>> +				| CLK_SET_RATE_NO_REPARENT);
> 
> Would you please remove CLK_SET_RATE_NO_REPARENT flag from here? Let me
> know if you have reservations against this.

The problem with clock reparenting is that there are certain parent
clocks of CLKOUT, rate of which changes at runtime, e.g. clocks derived
from APLL or bus clocks, which can be reconfigured by cpufreq or devfreq.

> 
> With RFC patches, I am able to do a clk_set_rate() on this clock to
> get a 24MHz output to the codec clock. With this flag set, I again have
> to rely on the default value set to this register in bootloader.
> 

This problem should be handled by initializing clocks from DT. I'm not
sure why it hasn't been implemented yet...

Best regards,
Tomasz
