Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3J2STb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:19:31 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:46350 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752815Ab3J2ST3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:19:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:3871:3873:4225:4250:4321:4605:5007:6119:6120:7652:7901:7903:10004:10400:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12679:12683:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: prose44_6fab7fb22f22a
X-Filterd-Recvd-Size: 2415
Message-ID: <1383070766.12439.13.camel@joe-AO722>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
From: Joe Perches <joe@perches.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: broonie@kernel.org, ning.li@intel.com, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Fei Yang <fei.yang@intel.com>
Date: Tue, 29 Oct 2013 11:19:26 -0700
In-Reply-To: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 11:05 -0700, David Cohen wrote:
> This patch adds driver for ssp spi interface on Intel Mid platform.

A few simple notes:

Please consider using checkpatch.

> ---
>  drivers/spi/Kconfig                   |   12 +
>  drivers/spi/Makefile                  |    1 +
>  drivers/spi/spi-intel-mid-ssp.c       | 1506 +++++++++++++++++++++++++++++++++
>  include/linux/spi/intel_mid_ssp_spi.h |  330 ++++++++

Shouldn't this include file be in the drivers/spi directory?

[]

> diff --git a/drivers/spi/spi-intel-mid-ssp.c b/drivers/spi/spi-intel-mid-ssp.c
[]
> +#ifdef DUMP_RX
> +static void dump_trailer(const struct device *dev, char *buf, int len, int sz)
> +{

You could save a couple of later #ifdefs by
moving the #ifdef inside the function

static void dump_trailer(etc)
{
#ifdef DUMP_RX
	...
#endif
}

> +static int map_dma_buffers(struct ssp_drv_context *sspc)
> +{
[]
> +#ifdef DUMP_RX
> +		dump_trailer(&sspc->pdev->dev, sspc->tx, sspc->len, 16);
> +#endif

> +static void int_transfer_complete(struct ssp_drv_context *sspc)
> +{
[]
> +#ifdef DUMP_RX
> +	dump_trailer(dev, sspc->rx, sspc->len, 16);
> +#endif

> +static int setup(struct spi_device *spi)
> +{
[]
> +	if (!chip) {
> +		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
> +		if (!chip) {
> +			dev_err(&spi->dev,
> +			"failed setup: can't allocate chip data\n");

OOM messages aren't necessary as a generic OOM message
is already emitted along with a dump_stack();


