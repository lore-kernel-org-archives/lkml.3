Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaBEPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:47:18 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35680 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751333AbaBEPrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:47:16 -0500
Date: Wed, 5 Feb 2014 16:47:10 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] mvebu : pcie: dt: potential issue in range parsing
Message-ID: <20140205164710.082f689e@skate>
In-Reply-To: <1389349431-7997-1-git-send-email-jjhiblot@traphandler.com>
References: <1389349431-7997-1-git-send-email-jjhiblot@traphandler.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean-Jacques Hiblot,

On Fri, 10 Jan 2014 11:23:51 +0100, Jean-Jacques Hiblot wrote:
> The second parameter of of_read_number is not the index, but a size.
> As it happens, in this case it may work just fine because of the the conversion
> to u32 and the favorable endianness on this architecture.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  drivers/pci/host/pci-mvebu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
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

Sorry for the long delay, and thanks for the fix!

Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

(on Armada 370, with PCIe cards plugged in)

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
