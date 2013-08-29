Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3H2Ork (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:47:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47464 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3H2Orh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:47:37 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-7c-521f5f08392c
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, mturquette@linaro.org, tomasz.figa@gmail.com,
        yadi.brar@samsung.com, dianders@chromium.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ian.campbell@citrix.com, rob@landley.net, thomas.abraham@linaro.org,
        s.nawrocki@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [RFC 1/3] clk: samsung: pll: Add support for PLL6545a and PLL6522x
Date: Thu, 29 Aug 2013 16:47:32 +0200
Message-id: <2050811.5PbvRtD2ku@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1377707357-4902-2-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377707357-4902-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377707357-4902-2-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xK7oc8fJBBn/nK1pMWneAyWL+kXOs
	FmeXHWSzeNPbwWLRu+Aqm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCxuX+a1OL3mFLPF0usXmSye
	TrjIZjFh+loWi3Uvp7NYHH7Tzmrx6mAbi8WxGUsYLVbt+sNoMWf6OyYHEY8189YwerQ097B5
	zG64yOLxevIERo+/q14we+ycdZfd49Xqmawed67tYfPYvKTe4+C7PUwefVtWMXp83iTnsXFu
	aABvFJdNSmpOZllqkb5dAlfGzuYWloKtnBU9uy+wNTA+YO9i5OCQEDCRuH6Dr4uRE8gUk7hw
	bz1bFyMXh5DAUkaJB1N7GCGcLiaJ1i8/GUGq2ATUJD43PGIDsUUETCXe3b0G1sEs8IpZYtnS
	+WAJYQF/iaf3WplBbBYBVYmj8/4zgWzjFdCUONwaBBLmF1CXeLftKVhYVMBFou9vJkiYU8BP
	4mXLKWaIvRMZJT4uO80CkuAVEJT4MfkemM0sIC+xb/9UVghbS2L9zuNMExgFZyEpm4WkbBaS
	sgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQiL56w7GpcesDjEKcDAq8fB2BMoHCbEm
	lhVX5h5ilOBgVhLhfcsJFOJNSaysSi3Kjy8qzUktPsTIxMEp1cC4Ys3y2OYmjwuL3inUGy/8
	9P4Ou8Sn7NchT/WihKW+PVRNzT76bstEWfFHYnem+76+OmXKg7jcSYW/OtyW5rCdeKmweVHs
	xJ8qczdK8qn3fzIRP2M/57Hc1aCdDvz+L40s4zqZy7Sy7ByMPVkYf/t0vTst9KyW3WiRf+30
	tnmCT+N+x+wsqPZSYinOSDTUYi4qTgQAG8PBIMICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Wednesday 28 of August 2013 18:29:15 Mateusz Krawczuk wrote:
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/clk/samsung/clk-pll.c | 2 ++
>  drivers/clk/samsung/clk-pll.h | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/clk/samsung/clk-pll.c
> b/drivers/clk/samsung/clk-pll.c index 7572d1d..c62ddfc 100644
> --- a/drivers/clk/samsung/clk-pll.c
> +++ b/drivers/clk/samsung/clk-pll.c
> @@ -644,6 +644,8 @@ static void __init _samsung_clk_register_pll(struct
> samsung_pll_clock *pll_clk, init.ops = &samsung_pll36xx_clk_ops;
>  		break;
>  	case pll_6552:
> +	case pll_6545a:
> +	case pll_6522x:
>  		init.ops = &samsung_pll6552_clk_ops;
>  		break;
>  	case pll_6553:
> diff --git a/drivers/clk/samsung/clk-pll.h
> b/drivers/clk/samsung/clk-pll.h index cd11037..7679c4c 100644
> --- a/drivers/clk/samsung/clk-pll.h
> +++ b/drivers/clk/samsung/clk-pll.h
> @@ -19,6 +19,8 @@ enum samsung_pll_type {
>  	pll_2650,
>  	pll_6552,
>  	pll_6553,
> +	pll_6545a,
> +	pll_6522x,
>  };
> 
>  #define PLL_35XX_RATE(_rate, _m, _p, _s)			\

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

