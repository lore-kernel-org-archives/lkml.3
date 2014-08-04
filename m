Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaHDJK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:10:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaHDJKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:10:55 -0400
Date: Mon, 4 Aug 2014 12:10:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com
Subject: Re: [PATCH] staging: media: as102: replace custom dprintk() with
 dev_dbg()
Message-ID: <20140804091023.GP4856@mwanda>
References: <1407077661-2411-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407077661-2411-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 04:54:21PM +0200, Martin Kepplinger wrote:
> @@ -447,6 +457,13 @@ static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
>  static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
>  			  struct dtv_frontend_properties *params)
>  {
> +	struct dvb_frontend *fe;
> +	struct as102_dev_t *dev;
> +
> +	fe = container_of(params, struct dvb_frontend, dtv_property_cache);
> +	dev = (struct as102_dev_t *) fe->tuner_priv;
> +	if (dev == NULL)
> +		dev_err(&dev->bus_adap.usb_dev->dev, "No device found\n");

NULL dereference in printing error message.  I think smatch or
coccinelle would detect this although I haven't tried either.

This is the typical bug for this kind of patch.

regards,
dan carpenter
