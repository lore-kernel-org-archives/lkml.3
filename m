Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaBEEFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:05:11 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12349 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753937AbaBEEFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:05:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ZoKRipwiPbkE9Wg4uqcFCP0fAG80zYAo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 70AFE51DB61
Date: Tue, 4 Feb 2014 23:05:02 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: thomas.petazzoni@free-electrons.com, gregory.clement@free-electrons.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mvebu : pcie: dt: potential issue in range parsing
Message-ID: <20140205040502.GM8533@titan.lakedaemon.net>
References: <1389349431-7997-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389349431-7997-1-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Jacques,

On Fri, Jan 10, 2014 at 11:23:51AM +0100, Jean-Jacques Hiblot wrote:
> The second parameter of of_read_number is not the index, but a size.
> As it happens, in this case it may work just fine because of the the conversion
> to u32 and the favorable endianness on this architecture.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  drivers/pci/host/pci-mvebu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Sorry for the unusually long delay.  I was waiting for Thomas to get
back from vacation since he is intimately familiar with this driver.

Thomas?

thx,

Jason.

> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> index c269e43..877e8ce 100644
> --- a/drivers/pci/host/pci-mvebu.c
> +++ b/drivers/pci/host/pci-mvebu.c
> @@ -768,7 +768,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
>  
>  	for (i = 0; i < nranges; i++) {
>  		u32 flags = of_read_number(range, 1);
> -		u32 slot = of_read_number(range, 2);
> +		u32 slot = of_read_number(range + 1, 1);
>  		u64 cpuaddr = of_read_number(range + na, pna);
>  		unsigned long rtype;
>  
> -- 
> 1.8.5.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
