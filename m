Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaGNJwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:52:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48737 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaGNJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:51:15 -0400
Message-ID: <53C3A7FE.8000401@gmail.com>
Date: Mon, 14 Jul 2014 11:50:54 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/6] ARM: EXYNOS: Fix core ID used by platsmp and hotplug
 code
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com> <1403618235-19353-3-git-send-email-t.figa@samsung.com> <031001cf9aaf$959cf6c0$c0d6e440$@samsung.com>
In-Reply-To: <031001cf9aaf$959cf6c0$c0d6e440$@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 08.07.2014 15:21, Kukjin Kim wrote:
> Tomasz Figa wrote:
>>
>> When CPU topology is specified in device tree, cpu_logical_map() does
>> not return core ID anymore, but rather full MPIDR value. This breaks
>> existing calculation of PMU register offsets on Exynos SoCs.
>>
>> This patch fixes the problem by adjusting the code to use only core ID
>> bits of the value returned by cpu_logical_map() to allow CPU topology to
>> be specified in device tree on Exynos SoCs.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> 
> Looks good to me, but I think we don't need this fix in 3.16 because the CPU
> topology is not specified in DT yet...if I'm wrong, please correct me.

CPU topology is already specified in DT for Exynos3250, 5250, 5260, 5410
and 5420/5800.

This patch also fixes CPU hotplug on SoCs with more than 2 cores,
because it removes incorrect condition check in platform_do_lowpower().

Please take this fix for next -rc release.

Best regards,
Tomasz
