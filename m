Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbaDJP15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:27:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59785 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030527AbaDJP1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:27:54 -0400
Date: Thu, 10 Apr 2014 11:27:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <kgene.kim@samsung.com>,
        <jg1.han@samsung.com>, Hauke Mehrtens <hauke@hauke-m.de>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 2/2] usb: ehci-platform: Return immediately from
 suspend if ehci_suspend fails
In-Reply-To: <1397125682-4955-2-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1404101127420.32351-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014, Vivek Gautam wrote:

> Patch 'b8efdaf USB: EHCI: add check for wakeup/suspend race'
> adds a check for possible race between suspend and wakeup interrupt,
> and thereby it returns -EBUSY as error code if there's a wakeup
> interrupt.
> So the platform host controller should not proceed further with
> its suspend callback, rather should return immediately to avoid
> powering down the essential things, like phy.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Hans de Goede <hdegoede@redhat.com>
> ---
> 
> Changes from v1:
> -- Removed unnecessary change 'return 0'
> 
>  drivers/usb/host/ehci-platform.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
> index b3a0e11..c7dd93a 100644
> --- a/drivers/usb/host/ehci-platform.c
> +++ b/drivers/usb/host/ehci-platform.c
> @@ -303,6 +303,8 @@ static int ehci_platform_suspend(struct device *dev)
>  	int ret;
>  
>  	ret = ehci_suspend(hcd, do_wakeup);
> +	if (ret)
> +		return ret;
>  
>  	if (pdata->power_suspend)
>  		pdata->power_suspend(pdev);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

