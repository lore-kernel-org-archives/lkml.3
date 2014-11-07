Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaKGL7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:59:33 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29025 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaKGL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:59:29 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-3b-545cb41ea2a7
Content-transfer-encoding: 8BIT
Message-id: <1415361564.31102.2.camel@AMDC1943>
Subject: Re: [PATCH] ARM: dts: Fix booting on Rinato market device
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        BartlomiejZolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 07 Nov 2014 12:59:24 +0100
In-reply-to: <545CB220.9030007@samsung.com>
References: <1415360662-30390-1-git-send-email-k.kozlowski@samsung.com>
 <545CB220.9030007@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xy7pyW2JCDJbfZLHYOGM9q8WkdQeY
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaNG74CqbxdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rVY
	ev0ik8WE6WtZLFr3HmF34PdYM28No0dLcw+bx+W+XiaPv6teMHusXP6FzWPTqk42j81L6j36
	tqxi9Pi8SS6AM4rLJiU1J7MstUjfLoErY3fXYqaC7YIVr07tZ25gnMzXxcjJISFgIjFj6TMW
	CFtM4sK99WxdjFwcQgJLGSV+7H3ODJLgFRCU+DH5HlARBwezgLzEkUvZIGFmAXWJSfMWMUPU
	f2aU2DhjEiNEvb7E8cfPmEBsYQEniYW7XrGB2GwCxhKbly8Bs0UENCRm/r3CCNLMLDCLRaJp
	wlywZSwCqhLvF68GG8QpoC2xo+86K4gtJJAh8eTpESaQIyQElCUa+90mMArMQnLeLITzZiE5
	bwEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLj6soNx8TGrQ4wCHIxKPLydQjEhQqyJ
	ZcWVuYcYJTiYlUR4AzYAhXhTEiurUovy44tKc1KLDzEycXBKNTB6WX0Pv7Gr7/YUQd8bHvX8
	nUUPXzizeQh/0N0heu73Lf/cWbF3d3KUWjB82K8hZbfl3eMCnbnFoYUiL4IYNgd+dhV2478h
	fv1nckO5Sa6dEI/sy1y+fxv2L5c4f9FHaeXWydve3Jyt21Wod0/UfN5/r4PnYzIa9t1Z1DX9
	QeiOvaKV7yv5s2yUWIozEg21mIuKEwGPYvChiQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-07 at 20:50 +0900, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> On 11/07/2014 08:44 PM, Krzysztof Kozlowski wrote:
> > The bootloader on market Rinato (Gear 2) device checks for revision in
> > compatible field of DTB. If it is not present or lower than required
> > then booting fails with: "Could not do normal boot. (no DTB found)".
> > 
> > Log of bootloader in case of failure:
> > h/w: revision  = 0x06
> > h/w: schematic = SM-R380_Rev0.5_Final_0205
> > date = 2000/01/01 12:00:21 (UTC)
> > cmu_div:4, div:5, src_clk:800000000, pixel_clk:31860720
> > load_kernel: loading boot image from 57344.. (BOOT)
> > load_kernel: found zImage, size: 0x3267e8
> > 0xbc Error!
> > Verify_Binary_Signature: failed.
> > pit_check_signature (BOOT) invalid.
> > load_kernel: found custom kernel (ret:-2147483647)
> >  No need to update kernel type.
> > Detected board: samsung,rinato-rev06
> > Could not do normal boot. (no DTB found)
> > : Entering usb mode for SM-R380_EUR_XX (65535)..
> > 
> > Add a "rev06" suffix to compatible to satisfy the bootloader.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  arch/arm/boot/dts/exynos3250-rinato.dts | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
> > index 84380fa13e37..f72ba0a1d915 100644
> > --- a/arch/arm/boot/dts/exynos3250-rinato.dts
> > +++ b/arch/arm/boot/dts/exynos3250-rinato.dts
> > @@ -18,7 +18,8 @@
> >  
> >  / {
> >  	model = "Samsung Rinato board";
> > -	compatible = "samsung,rinato", "samsung,exynos3250", "samsung,exynos3";
> > +	compatible = "samsung,rinato", "samsung,rinato-rev06",
> > +			"samsung,exynos3250", "samsung,exynos3";
> 
> I think it is wrong. The released bootloader from Samsung is not u-boot.
> Instead, you have to update u-boot to support Exynos3250-basd Rinato board.

The bootloader on device also was not a u-boot. So the fix is for native
bootloader delivered on device.

I do not insist that this is proper fix. It was just needed to boot the
device with custom kernel.

Anyway, thanks for comments!

Best regards,
Krzysztof

