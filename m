Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbaJXN2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:28:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64666 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbaJXN2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:28:09 -0400
Message-ID: <544A53E3.7040501@gmail.com>
Date: Fri, 24 Oct 2014 15:28:03 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Drake <drake@endlessm.com>, Chanwoo Choi <cw00.choi@samsung.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, ben-linux@fluff.org,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>, thomas.abraham@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        InKi Dae <inki.dae@samsung.com>, geunsik.lim@samsung.com,
        jh80.chung@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/5] clk: samsung: exynos4415: Add clocks using common
 clock framework
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>	<1413775935-17743-2-git-send-email-cw00.choi@samsung.com> <CAD8Lp45F_6UWXx0f2xVGZL+Rgemg2fzkYhnfPdaeaiky0rKPgw@mail.gmail.com>
In-Reply-To: <CAD8Lp45F_6UWXx0f2xVGZL+Rgemg2fzkYhnfPdaeaiky0rKPgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2014 15:18, Daniel Drake wrote:
> On Sun, Oct 19, 2014 at 9:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
>> using common clock framework. The CMU (Clock Management Unit) of Exynos4415
>> controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
>> and function clocks for individual IPs.
> 
> There seems to be a lot in common here with other exynos4 variants in
> clk-exynos4.c. Have you considered just adding support for the 4415 in
> the existing driver?

I tried when I was still at Samsung and the outcome was far from being
nice. There are certain differences, such as separate address spaces of
few clock controllers and different bit fields in apparently similar
registers, which made resulting code quite ugly.

Also another advantage of separate driver is that it can be made without
duplicating initial fails of the driver for Exynos4, such as private
bindings for external clocks or clock controllers in different power
domains grouped together into one big logical clock controller, because
at development time they looked so (contiguous address space).

Best regards,
Tomasz
