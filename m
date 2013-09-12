Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3ILMFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:05:10 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:47986 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3ILMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:05:08 -0400
Date: Thu, 12 Sep 2013 09:05:00 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ehea: remove deprecated IRQF_DISABLED
Message-ID: <20130912120500.GB28361@oc0268524204.ibm.com>
References: <1378957571-3574-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378957571-3574-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091212-2362-0000-0000-00000BC35B00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:46:11AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/ibm/ehea/ehea_main.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/net/ethernet/ibm/ehea/ehea_main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> index 35853b4..04e0ef1 100644
> --- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
> +++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> @@ -1285,7 +1285,7 @@ static int ehea_reg_interrupts(struct net_device *dev)
> 
>  	ret = ibmebus_request_irq(port->qp_eq->attr.ist1,
>  				  ehea_qp_aff_irq_handler,
> -				  IRQF_DISABLED, port->int_aff_name, port);
> +				  0, port->int_aff_name, port);
>  	if (ret) {
>  		netdev_err(dev, "failed registering irq for qp_aff_irq_handler:ist=%X\n",
>  			   port->qp_eq->attr.ist1);
> @@ -1303,8 +1303,7 @@ static int ehea_reg_interrupts(struct net_device *dev)
>  			 "%s-queue%d", dev->name, i);
>  		ret = ibmebus_request_irq(pr->eq->attr.ist1,
>  					  ehea_recv_irq_handler,
> -					  IRQF_DISABLED, pr->int_send_name,
> -					  pr);
> +					  0, pr->int_send_name, pr);
>  		if (ret) {
>  			netdev_err(dev, "failed registering irq for ehea_queue port_res_nr:%d, ist=%X\n",
>  				   i, pr->eq->attr.ist1);
> @@ -3320,7 +3319,7 @@ static int ehea_probe_adapter(struct platform_device *dev)
>  	}
> 
>  	ret = ibmebus_request_irq(adapter->neq->attr.ist1,
> -				  ehea_interrupt_neq, IRQF_DISABLED,
> +				  ehea_interrupt_neq, 0,
>  				  "ehea_neq", adapter);
>  	if (ret) {
>  		dev_err(&dev->dev, "requesting NEQ IRQ failed\n");
> -- 
> 1.8.1.2
> 

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

