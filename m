Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaJ0Q54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:57:56 -0400
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:48247 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751113AbaJ0Q5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:57:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:4250:4321:4385:5007:6119:6261:6742:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smile21_a4b63f4fcf61
X-Filterd-Recvd-Size: 2541
Message-ID: <1414429069.8884.10.camel@perches.com>
Subject: Re: [PATCH v9 1/4] mfd: add support for Diolan DLN-2 devices
From: Joe Perches <joe@perches.com>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Date: Mon, 27 Oct 2014 09:57:49 -0700
In-Reply-To: <1414427472-4100-2-git-send-email-octavian.purdila@intel.com>
References: <1414427472-4100-1-git-send-email-octavian.purdila@intel.com>
	 <1414427472-4100-2-git-send-email-octavian.purdila@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 18:31 +0200, Octavian Purdila wrote:
> This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
> Master Adapter DLN-2. Details about the device can be found here:

trivia:

> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
[]
> +static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
> +			  const void *obuf, unsigned obuf_len,
> +			  void *ibuf, unsigned *ibuf_len)
> +{
> +	int ret = 0;
> +	int rx_slot;
> +	struct dln2_response *rsp;
> +	struct dln2_rx_context *rxc;
> +	struct device *dev = &dln2->interface->dev;
> +	const int timeout = DLN2_USB_TIMEOUT * HZ / 1000;

unsigned long timeout?

[]

> +	ret = wait_for_completion_interruptible_timeout(&rxc->done, timeout);
> +	if (ret <= 0) {
> +		if (!ret)
> +			ret = -ETIMEDOUT;
> +		goto out_free_rx_slot;
> +	}

[]

> +static int dln2_print_serialno(struct dln2_dev *dln2)
> +{
> +	int ret;
> +	__le32 serial_no;
> +	int len = sizeof(serial_no);
> +	struct device *dev = &dln2->interface->dev;
> +
> +	ret = _dln2_transfer(dln2, DLN2_HANDLE_CTRL, CMD_GET_DEVICE_SN, NULL, 0,
> +			     &serial_no, &len);
> +	if (ret < 0)
> +		return ret;
> +	if (len < sizeof(serial_no))
> +		return -EREMOTEIO;
> +
> +	dev_info(dev, "Diolan DLN2 serial 0x%x\n", le32_to_cpu(serial_no));

why a hex serial #?


