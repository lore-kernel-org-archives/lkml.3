Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687Ab3BTSsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:48:12 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58809 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934293Ab3BTSsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:48:10 -0500
Date: Wed, 20 Feb 2013 10:48:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: Re: [PATCH v5 3/6] mfd: Add ChromeOS EC I2C driver
Message-ID: <20130220184802.GE15152@core.coreip.homeip.net>
References: <1361381079-26747-1-git-send-email-sjg@chromium.org>
 <1361381079-26747-4-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361381079-26747-4-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 09:24:36AM -0800, Simon Glass wrote:
> +#ifdef DEBUG
> +	dev_dbg(ec_dev->dev, "packet: ");
> +	for (i = 0; i < i2c_msg[1].len; i++)
> +		dev_cont(ec_dev->dev, " %02x", in_buf[i]);
> +	dev_cont(ec_dev->dev, ", sum = %02x\n", sum);

There is "%ph" now so you can simply write:

	dev_dbg(ec_dev->dev, "packet: %*ph, sum = %02x\n",
		i2c_msg[1].len, in_buf[i], sum);

> +#endif

Thanks.

-- 
Dmitry
