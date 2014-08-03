Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaHCNQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 09:16:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:54970 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaHCNQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 09:16:31 -0400
Message-ID: <53DE3629.2020706@kernel.org>
Date: Sun, 03 Aug 2014 09:16:25 -0400
From: Sasha Levin <sashal@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Nicholas Krause <xerofoify@gmail.com>
Subject: Re: [PATCH] ARM: PCI: Use PCI_CLASS_* defines for PCI class
References: <1406904671-19197-1-git-send-email-lisovy@gmail.com>
In-Reply-To: <1406904671-19197-1-git-send-email-lisovy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 10:51 AM, Rostislav Lisovy wrote:
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> ---
>  arch/arm/kernel/bios32.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 17a26c1..e511ad1 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -255,10 +255,9 @@ static void pci_fixup_it8152(struct pci_dev *dev)
>  {
>  	int i;
>  	/* fixup for ITE 8152 devices */
> -	/* FIXME: add defines for class 0x68000 and 0x80103 */
>  	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
> -	    dev->class == 0x68000 ||
> -	    dev->class == 0x80103) {
> +	    dev->class == (PCI_CLASS_BRIDGE_OTHER << 8) ||
> +	    dev->class == ((PCI_CLASS_SYSTEM_DMA << 8) | 0x03)) {
>  		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>  			dev->resource[i].start = 0;
>  			dev->resource[i].end   = 0;
> 

Care to explain how your new code is equivalent to the old one?


Thanks,
Sasha
