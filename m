Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3HZUba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:31:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41485 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3HZUb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:31:28 -0400
Date: Mon, 26 Aug 2013 16:31:25 -0400 (EDT)
Message-Id: <20130826.163125.1134768821551948034.davem@davemloft.net>
To: mrkiko.rs@gmail.com
Cc: gregkh@linuxfoundation.org, oliver@neukum.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND V3 net-next 2/3] net: huawei_cdc_ncm: Introduce
 the huawei_cdc_ncm driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377244590-8558-3-git-send-email-mrkiko.rs@gmail.com>
References: <mrkiko.rs@gmail.com>
	<1377244590-8558-1-git-send-email-mrkiko.rs@gmail.com>
	<1377244590-8558-3-git-send-email-mrkiko.rs@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 26 Aug 2013 13:31:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Enrico Mioso <mrkiko.rs@gmail.com>
Date: Fri, 23 Aug 2013 09:56:29 +0200

> +	if ((on && atomic_add_return(1, &drvstate->pmcount) == 1) || (!on && atomic_dec_and_test(&drvstate->pmcount))) {

These line significantly exceeds 80 columns.

> +		subdriver = usb_cdc_wdm_register(ctx->control,
> +						 &usbnet_dev->status->desc,
> +						 256, /* CDC-WMC r1.1 requires wMaxCommand to be "at least 256 decimal (0x100)" */
> +						 huawei_cdc_ncm_wdm_manage_power);

Likewise.

> +	if (intf == ctx->control && drvstate->subdriver && drvstate->subdriver->suspend)

Likewise.

> +	int ret = 0;
> +	struct usbnet *usbnet_dev = usb_get_intfdata(intf);
> +	struct huawei_cdc_ncm_state *drvstate = (void *)&usbnet_dev->data;
> +	struct cdc_ncm_ctx *ctx = drvstate->ctx;
> +	bool callsub = (intf == ctx->control && drvstate->subdriver && drvstate->subdriver->resume); /* should we call subdriver's resume? ? */

Likewise, and order local function variable declarations by line
length, longest to shortest.

