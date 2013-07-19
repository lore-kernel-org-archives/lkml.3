Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab3GSQOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:14:17 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56854 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3GSQOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:14:16 -0400
X-Auth-Info: CiSzMnmBh88PWlTDgiXtDFSe538EnfDuGPUBFnnQavQ=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH v2 3/5] iio: mxs-lradc: add scale attribute to channels
Date: Fri, 19 Jul 2013 18:14:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <201307191630.17149.marex@denx.de> <51E95EF1.4040503@digi.com>
In-Reply-To: <51E95EF1.4040503@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307191814.15491.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Dear Marek,
> 
> On 07/19/2013 04:30 PM, Marek Vasut wrote:
> >> @@ -228,39 +230,12 @@ struct mxs_lradc {
> >> 
> >>   #define LRADC_RESOLUTION			12
> >>   #define LRADC_SINGLE_SAMPLE_MASK		((1 << LRADC_RESOLUTION) - 1)
> >> 
> >> -/*
> >> - * Raw I/O operations
> >> - */
> >> -static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
> >> +static int mxs_lradc_read_single(struct iio_dev *iio_dev,
> >> 
> >>   			const struct iio_chan_spec *chan,
> >>   			int *val, int *val2, long m)
> >>   
> >>   {
> >>   
> >>   	struct mxs_lradc *lradc = iio_priv(iio_dev);
> >>   	int ret;
> >> 
> >> -	unsigned long mask;
> >> -
> >> -	if (m != IIO_CHAN_INFO_RAW)
> >> -		return -EINVAL;
> >> -
> >> -	/* Check for invalid channel */
> >> -	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
> >> -		return -EINVAL;
> > 
> > This was already resolved, so this patch won't apply I'm afraid.
> 
> You mean the 'unsigned long mask', right?  Yeah, I think I had resolved
> that one before submitting, but looks like I didn't.
> The other check is not resolved afaik. We agreed to remove it, but on a
> different patch.

I mean the other check, yeah. A patch removing that should be applied already.

Best regards,
Marek Vasut
