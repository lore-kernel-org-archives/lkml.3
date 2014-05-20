Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaETRss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:48:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37399 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaETRsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:48:45 -0400
Message-ID: <537B957B.5010001@codeaurora.org>
Date: Tue, 20 May 2014 10:48:43 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>, linux-pm@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Michal Simek <michal.simek@xilinx.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com> <1400106655-22465-3-git-send-email-soren.brinkmann@xilinx.com> <20140515073816.GI16662@pengutronix.de> <91822600-39d0-4e71-b0f5-9eda35b76ec0@BN1AFFO11FD016.protection.gbl> <20140519161949.GG16662@pengutronix.de> <db8633e5-01a9-4d3a-80e8-74e23a456d52@BN1BFFO11FD051.protection.gbl> <20140520073358.GJ16662@pengutronix.de> <4bb5f44a-60bb-4e34-8f88-f91b8419be8d@BL2FFO11FD050.protection.gbl>
In-Reply-To: <4bb5f44a-60bb-4e34-8f88-f91b8419be8d@BL2FFO11FD050.protection.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/14 09:01, Sören Brinkmann wrote:
>
>>>>> +{
>>>>> +	unsigned long lower, upper, cur, lower_last, upper_last;
>>>>> +
>>>>> +	lower = clk_round_rate(clk, rate);
>>>>> +	if (lower >= rate)
>>>>> +		return lower;
>>>> Is the >-case worth a warning?
>>> No, it's correct behavior. If you request a rate that is way lower than what the
>>> clock can generate, returning something larger is perfectly valid, IMHO.
>>> Which reveals one problem in this whole discussion. The API does not
>>> require clk_round_rate() to round down. It is actually an implementation
>>> choice that had been made for clk-divider.
>> I'm sure it's more than an implementation choice for clk-divider. But I
>> don't find any respective documentation (but I didn't try hard).
> A similar discussion - without final conclusion:
> https://lkml.org/lkml/2010/7/14/260
>
>

Please call this new API something like clk_find_nearest_rate() or
something. clk_round_rate() is supposed to return the rate that will be
set if you call clk_set_rate() with the same arguments. It's up to the
implementation to decide if that means rounding the rate up or down or
to the nearest value.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

