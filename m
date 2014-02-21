Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaBUQZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:25:12 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10128 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaBUQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:25:10 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-63-53077de44aca
Message-id: <53077DE0.7080108@samsung.com>
Date: Fri, 21 Feb 2014 17:25:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: kishon@ti.com, linux-samsung-soc@vger.kernel.org, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for
 ARCH_EXYNOS
References: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com>
 <1392997802-29050-2-git-send-email-s.nawrocki@samsung.com>
 <1753680.KKj0Q1erxA@wuerfel>
In-reply-to: <1753680.KKj0Q1erxA@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xa7pPatmDDTacZLX4O+kYu8XlhZdY
	LS487WGz2PT4GqvF5V1z2CxmnN/H5MDm8fvXJEaPzUvqPfq2rGL0OH5jO5PH501yAaxRXDYp
	qTmZZalF+nYJXBmfJu5lLDjPWjH/TDt7A+NEli5GTg4JAROJww+vsEHYYhIX7q0Hs4UEljJK
	fOuJh7A/MUrcm8MJYvMKaEkcOrSOEcRmEVCV+HZpGhOIzSZgKNF7tA8sLioQIfHqLMR8XgFB
	iR+T74HZIgLuEuumz2MFsZkFMiUezN8DVi8MVH934Q4gmwto1yJGicZv85lBEpwCmhI7Ph2A
	atCR2N86jQ3ClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGCGB/XUH49JjVocYBTgYlXh4HVLZg4VYE8uKK3MPMUpwMCuJ8DZHA4V4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUwHrktnezyxO3LJdfOyvn8djH5pY+SWr8G5zDujLze1Xj6wc7ovgLHjNML
	H5gsZKjy0noltfDG0nlX2Vn3W/N3GIevU1U9z8K2Q1o4a94SKwGP1453pRqk38z6ZCm9Q+NK
	ZOaB7tAnv97fW9f2fJk/42efYoV3715xT5YQeZTbPWFOWDfT9rmVSizFGYmGWsxFxYkAE7vI
	wkoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/14 16:59, Arnd Bergmann wrote:
> On Friday 21 February 2014 16:50:02 Sylwester Nawrocki wrote:
>>  config PHY_EXYNOS_DP_VIDEO
>>         tristate "EXYNOS SoC series Display Port PHY driver"
>>         depends on OF
>> +       depends on ARCH_EXYNOS || COMPILE_TEST
>> +       default y
>>         select GENERIC_PHY
>>         help
>>
> 
> That would turn them on automatically if you enable COMPILE_TEST, which
> is probably not what you want.
> 
> How about "default ARCH_EXYNOS"?

Hmm, good point, I will modify it that way.

For patch 1/2 I guess it should be:

"default ARCH_S5PV210 || ARCH_EXYNOS"

or rather

"default y if ARCH_S5PV210 || ARCH_EXYNOS" ?

Thanks,
Sylwester

