Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3EIT1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:27:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39813 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752963Ab3EIT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:27:36 -0400
Date: Thu, 9 May 2013 15:27:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Libo Chen <libo.chen@huawei.com>
cc: grant.likely@linaro.org, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 3/4] usb: ohci: fix goto wrong tag in err case
In-Reply-To: <1368079537-15328-4-git-send-email-libo.chen@huawei.com>
Message-ID: <Pine.LNX.4.44L0.1305091525510.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 May 2013, Libo Chen wrote:

> fix goto wrong tag in usb_hcd_nxp_probe
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/ohci-nxp.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
> index f4988fb..eb294a9 100644
> --- a/drivers/usb/host/ohci-nxp.c
> +++ b/drivers/usb/host/ohci-nxp.c
> @@ -234,7 +234,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
>  	if (usb_disabled()) {
>  		dev_err(&pdev->dev, "USB is disabled\n");
>  		ret = -ENODEV;
> -		goto out;
> +		goto out1;
>  	}

Instead of renumbering all these statement labels, it would be better 
to replace them with names that have a real meaning.  That would 
simplify future fixes.

Can you submit a patch to do that instead?

Alan Stern

