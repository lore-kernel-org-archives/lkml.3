Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbbATOEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:04:13 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44817 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbbATOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:04:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0c-54be60575f1c
Message-id: <54BE6050.1090205@samsung.com>
Date: Tue, 20 Jan 2015 15:04:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene@kernel.org>, Mike Turquette <mturquette@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tobias Jakobi <liquid.acid@gmx.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: exynos5420: Add IDs for clocks used in DISP1
 power domain
References: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
 <1421750127-22536-2-git-send-email-javier.martinez@collabora.co.uk>
In-reply-to: <1421750127-22536-2-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e/4Zd3whH0hBue/KVncWneO1eLjqdus
	FmeXHWSzOPq7wOLFvYssFq9fGFr0P37NbPH18ApGi02Pr7FaXN41h81ixvl9TBZdP3+yWaw9
	cpfd4umEi2wWp65/ZrOYsugwq8WqXX8YHQQ9ZjdcZPH4+/w6i8fOWXfZPRZv2s/msWlVJ5vH
	nWt72Dw2L6n3uHKiidWjb8sqRo/Pm+QCuKK4bFJSczLLUov07RK4Mn609bAVHOKqOHKxl7WB
	cSdHFyMnh4SAicS/Re+YIGwxiQv31rN1MXJxCAksZZT4Pv8KO4TziVHi1vV5jCBVvAJaEhvO
	b2ADsVkEVCV+LZnIDGKzCRhK9B7tA6sRFYiQOHl3DztEvaDEj8n3WEAGiQi0M0q8nrIGbCqz
	wDIWid1fe8GqhAUiJbY/+M4CsW4qo8Th3jNgR3EKBEhs2/sVqIgDqENP4v5FLZAws4C8xOY1
	b5knMArMQrJkFkLVLCRVCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKERN6XHYyLj1kd
	YhTgYFTi4dXI2RMixJpYVlyZe4hRgoNZSYT3rPm+ECHelMTKqtSi/Pii0pzU4kOMTBycUg2M
	FssrFnHx9c1OWCwiz3i3pWxjSMAm2W+17wK/PVnEIDx/f73CqwR+zysbb/byMIrzPHsh/u/1
	C/m0gmMbN+aoGluJhWffsu7fytJ42/bPq6REvYW1jAc6mVUsdmbNyI5e8Sbkxe4zb672/BRR
	NWnh3+54+/M8yZPiX+szJ7cd935vsrq6tlxKiaU4I9FQi7moOBEAA7y4s5oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20/01/15 11:35, Javier Martinez Canillas wrote:
> When a power domain is powered off on Exynos5420 SoC, the input clocks of
> the devices attached to this power domain are re-parented to oscclk and
> restored to the original parent after powering on the power domain.
> 
> So a reference to the input and parent clocks for the devices attached to
> a power domain are needed to be able to do the re-parenting. The DISP1 pd
> includes modules which uses the following clocks:
> 
> ACLK_200_DISP1 (MIXER and HDMILINK)
> ACLK_300_DISP1 (FIMD1)
> ACLK_400_DISP1 (Internal Buses)
> 
> Each of these clocks are generated as the output of a clock mux so add an
> ID for all of these clock muxes and their parents to be referenced in the
> DISP1 power domain device node.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

The patch looks OK to me, I'm fine with it being merged via Kukjin's tree
due to the dts dependencies (including other pending dts patches touching
the arch/arm/boot/dts/exynos5420.dtsi file).
I think we need also Mike ACK for that, I could also queue the patch for
the clk tree and create a topic branch, but merging both patches via
arm-soc seems a more sane option in this case.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester

