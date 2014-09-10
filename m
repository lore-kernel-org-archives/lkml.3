Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaIJIEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:04:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15474 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaIJIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:04:18 -0400
X-AuditID: cbfee61b-f79f86d00000144c-76-541005ff95e7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHv3 1/3] [media] disable OMAP1 COMPILE_TEST
Date: Wed, 10 Sep 2014 10:04:12 +0200
Message-id: <3055703.v1cXzV8T6U@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
References: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jAd3/rAIhBpMWGli83ziPyeLyrjls
	Fj0btrJaHFzYxmhxcZ28xY5Ti5gttu69yu7A7tF44wabx4ePcR6bV2h59G1ZxejxeZNcAGsU
	l01Kak5mWWqRvl0CV8an1S/ZCvp4KqZ+vsvawPiZs4uRk0NCwERi5r0PzBC2mMSFe+vZQGwh
	gUWMEq3fRbsYuYDsFiaJbU2f2UESbAJWEhPbVzGC2CICBhKPF51kByliFmhkkriy9CbYJGEB
	W4lLl9cygdgsAqoSz24cYgGxeQU0JVY1zAKzRQU8JXZsXwm2jVMgVqJjeTcrxLa1jBLTT09h
	hmgQlPgx+R5YA7OAvMS+/VNZIWwdif2t09gmMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEh/gz6R2MqxosDjEKcDAq8fAK1PKHCLEmlhVX5h5ilOBgVhLhnfUK
	KMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoEx30ttcVue
	+pUpzCqP9zGnvrf4ofwler5yr1xfROrXksN8C/X4Rf+8WcV5fE37Y4M3L2wXLW57vWavoNfF
	upObHzk+j3C9eF/mmbvLm1de9kKci2bk/2FleP634eMz2TeidizTBB/+Twqr4fcvZzlvGbLo
	fFxZnrNBwizBZawJMWd3dj3N4l2gxFKckWioxVxUnAgA2s+q120CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, September 09, 2014 03:54:04 PM Mauro Carvalho Chehab wrote:
> This driver depends on a legacy OMAP DMA API. So, it won't
> compile-test on other archs.
> 
> While we might add stubs to the functions, this is not a
> good idea, as the hole API should be replaced.

This is also not a good idea becaouse it would break the driver
for OMAP1 once somebody enables COMPILE_TEST option while also
having ARCH_OMAP1 enabled (which is perfectly fine and shouldn't
cause the driver breakage).  In general COMPILE_TEST option is
completely independent from the arch specific ones and it should
not change behaviour of the existing code.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> So, for now, let's just remove COMPILE_TEST and wait for
> some time for people to fix. If not fixed, then we'll end
> by removing this driver as a hole.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 6af6c6dccda8..f2776cd415ca 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -63,7 +63,7 @@ config VIDEO_SH_MOBILE_CEU
>  config VIDEO_OMAP1
>  	tristate "OMAP1 Camera Interface driver"
>  	depends on VIDEO_DEV && SOC_CAMERA
> -	depends on ARCH_OMAP1 || COMPILE_TEST
> +	depends on ARCH_OMAP1
>  	depends on HAS_DMA
>  	select VIDEOBUF_DMA_CONTIG
>  	select VIDEOBUF_DMA_SG

