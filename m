Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3D2Ld3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:33:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36563 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3D2Ld2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:33:28 -0400
Message-ID: <517E5A38.7050609@cogentembedded.com>
Date: Mon, 29 Apr 2013 15:32:08 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] AHCI: Make distinct names for ports in /proc/interrupts
References: <20130429101237.GA27738@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20130429101237.GA27738@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-04-2013 14:12, Alexander Gordeev wrote:

> Currently all interrupts assigned to AHCI ports show up in
> '/proc/interrupts' as 'ahci'. This fix adds port numbers as
> suffixes and hence makes the descriptions distinct.

> Reported-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>   drivers/ata/ahci.c |    6 ++++--
>   drivers/ata/ahci.h |    1 +
>   2 files changed, 5 insertions(+), 2 deletions(-)

> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 3b9a7b1..dc5c1aa 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1146,10 +1146,12 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis,
>   			return -EINVAL;
>
>   		for (i = 0; i < n_irqs; i++) {
> +			struct ahci_port_priv *pp = host->ports[i]->private_data;

    Empty line wouldn't hurt here, after declaration.

> +			snprintf(pp->irq_desc, sizeof(pp->irq_desc),
> +				 "%s%d", dev_driver_string(host->dev), i);
>   			rc = devm_request_threaded_irq(host->dev, irq + i,
>   				ahci_multi_irqs_intr, ahci_port_thread_fn,
> -				IRQF_SHARED, dev_driver_string(host->dev),
> -				host->ports[i]);
> +				IRQF_SHARED, pp->irq_desc, host->ports[i]);
>   			if (rc)
>   				goto out_free_irqs;
>   		}

WBR, Sergei

