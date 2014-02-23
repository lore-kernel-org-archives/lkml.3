Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaBWWP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:15:26 -0500
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:37983 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751592AbaBWWPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:15:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3871:3872:3876:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:124
X-HE-Tag: cup54_689e2fae6f21a
X-Filterd-Recvd-Size: 1906
Message-ID: <1393193717.11020.12.camel@joe-AO722>
Subject: Re: [RFCv2 5/5] mfd: twl4030-madc: Move driver to drivers/iio/adc
From: Joe Perches <joe@perches.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Date: Sun, 23 Feb 2014 14:15:17 -0800
In-Reply-To: <1393193271-16717-6-git-send-email-sre@debian.org>
References: <20140223220140.GA1258@earth.universe>
	 <1393193271-16717-1-git-send-email-sre@debian.org>
	 <1393193271-16717-6-git-send-email-sre@debian.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-23 at 23:07 +0100, Sebastian Reichel wrote:
> This is a driver for an A/D converter, which belongs into
> drivers/iio/adc.

Please use git format-patch -M

> diff --git a/drivers/iio/adc/twl4030-madc.c b/drivers/iio/adc/twl4030-madc.c
[]
> +static int twl4030_madc_read(struct iio_dev *iio_dev,
> +			     const struct iio_chan_spec *chan,
> +			     int *val, int *val2, long mask)
> +{
[]
> +	req.do_avg = !!(mask & IIO_CHAN_INFO_AVERAGE_RAW);

It looks like do_avg should be bool not u16


