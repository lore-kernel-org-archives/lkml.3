Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3ATWYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:24:24 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47772 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab3ATWYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:24:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v9 02/11] PCI: Add root bus children dev's res to fail list
Date: Sun, 20 Jan 2013 23:30:19 +0100
Message-ID: <150971283.gyvyveDduR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358495602-22867-3-git-send-email-yinghai@kernel.org>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org> <1358495602-22867-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 17, 2013 11:53:13 PM Yinghai Lu wrote:
> We can stop trying according to try_number now and do not need to use
> root_bus checking as stop sign.
> 
> In extreme case we could need to reallocate resource for device just
> under root bus. For pci root bus hot-add, we need to retry to assign
> resources to pci devices just under pci root bus.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
