Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaLELWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:22:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26451 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLELWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:22:19 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c9-548195697832
Message-id: <5481955A.9000703@samsung.com>
Date: Fri, 05 Dec 2014 12:22:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 1/3] clk: samsung: Fix clock disable failure because
 domain being gated
References: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
 <1417777254-26579-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1417777254-26579-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7qZUxtDDN7vYrfYOGM9q0XblYPs
	Fkd/F1i8fmFo0f/4NbPF082PmSzONr1ht9j0+BqrxeVdc9gsZpzfx2Sx9shddounEy6yWaza
	9YfRgdfj7/PrLB47Z91l99i0qpPN4861PWwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5d
	AlfGwq6frAU7uStWLprO0sC4nbOLkYNDQsBE4vrX+i5GTiBTTOLCvfVsXYxcHEICSxkltj27
	wwzhfGKUaP93iRmkildAS2LLwwYwm0VAVeL1psusIDabgKFE79E+RhBbVCBC4uTdPewQ9YIS
	PybfYwGxRQTCJHb9XsoCMpRZ4AazxLtrk9hAEsICCRLXDz5kgdjWyiix8mEbE0iCU8BDYmvP
	XVaQU5kF9CTuX9QCCTMLyEtsXvOWeQKjwCwkO2YhVM1CUrWAkXkVo2hqaXJBcVJ6rpFecWJu
	cWleul5yfu4mRki8fN3BuPSY1SFGAQ5GJR7eH3GNIUKsiWXFlbmHGCU4mJVEePk7gUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoYe9142vhFp26x3JvHxvzrQJzenvQlp1+573E9XLa34Jr3MSU9
	3VCXK0/8pFk98i/se3v5+rvkSP9TDGItnJvY4r24Y4TYo9RTrdUOBKqLl22bmbB04ZmPhd4M
	6uFMXy/XCTMG2Tw4EXxNUE2Vif+Az05Zxl/XFszlsFZ5a2jF1f/lw92lL12UWIozEg21mIuK
	EwElUqBgdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On 05/12/14 12:00, Krzysztof Kozlowski wrote:
> Audio subsystem clocks are located in separate block. If clock for this
> block (from main clock domain) 'mau_epll' is gated then any read or
> write to audss registers will block.
> 
> This was observed on Exynos 5420 platforms (Arndale Octa and Peach
> Pi/Pit) after introducing runtime PM to pl330 DMA driver. After that
> commit the 'mau_epll' was gated, because the "amba" clock was disabled
> and there were no more users of mau_epll. The system hang on disabling
> unused clocks from audss block.
> 
> Unfortunately the 'mau_epll' clock is not parent of some of audss clocks.
> 
> Whenever system wants to operate on audss clocks it has to enable epll
> clock. The solution reuses common clk-gate/divider/mux code and duplicates
> clk_register_*() functions.
> 
> Additionally this patch fixes memory leak of clock gate/divider/mux
> structures. The leak exists in generic clk_register_*() functions. Patch
> replaces them with custom code with managed allocation.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reported-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Can you confirm sound works with this patch on exynos5420 ? Or does
your Tested-by refer only to successful booting ?

--
Thanks,
Sylwester
