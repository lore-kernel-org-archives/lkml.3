Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3ALVbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:31:49 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39068 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3ALVbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:31:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 02/22] PCI: Add root bus children dev's res to fail list
Date: Sat, 12 Jan 2013 22:37:09 +0100
Message-ID: <6423213.ATyOvMNh1o@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-3-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:29 PM Yinghai Lu wrote:
> We can stop trying according to try number now and do not need to use
> root_bus checking as stop sign anymore.
> 
> In extreme case we could need to reallocate resource for device just
> under root bus.

Well, the above says that we _can_ do the change, but it doesn't explain why it
is needed.  So what's the reason why we need to do that?

Rafael


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 6d3591d..7e8739e 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -283,7 +283,7 @@ static void assign_requested_resources_sorted(struct list_head *head,
>  		idx = res - &dev_res->dev->resource[0];
>  		if (resource_size(res) &&
>  		    pci_assign_resource(dev_res->dev, idx)) {
> -			if (fail_head && !pci_is_root_bus(dev_res->dev->bus)) {
> +			if (fail_head) {
>  				/*
>  				 * if the failed res is for ROM BAR, and it will
>  				 * be enabled later, don't add it to the list
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
