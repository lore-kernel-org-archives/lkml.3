Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaJAH3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:29:09 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:63595 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbaJAH3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:29:07 -0400
Message-ID: <1412148544.21730.36.camel@x220>
Subject: Re: [PATCH] ssb: Fix Sparse error in main
From: Paul Bolle <pebolle@tiscali.nl>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <m@bues.ch>,
        netdev@vger.kernel.org
Date: Wed, 01 Oct 2014 09:29:04 +0200
In-Reply-To: <1412147196-7466-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412147196-7466-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2014 07:29:04.0612 (UTC) FILETIME=[60F60240:01CFDD49]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 12:36 +0530, Pramod Gurav wrote:
> This change fixes below sparse error:
> 
> drivers/ssb/main.c:94:16: warning: symbol 'ssb_sdio_func_to_bus'
> was not declared. Should it be static?
> 
> Cc: Michael Buesch <m@bues.ch>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/ssb/ssb_private.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
> index eb507a5..86bbbe3 100644
> --- a/drivers/ssb/ssb_private.h
> +++ b/drivers/ssb/ssb_private.h
> @@ -193,6 +193,7 @@ extern struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev);
>  int ssb_for_each_bus_call(unsigned long data,
>  			  int (*func)(struct ssb_bus *bus, unsigned long data));
>  extern struct ssb_bus *ssb_pcmcia_dev_to_bus(struct pcmcia_device *pdev);
> +struct ssb_bus *ssb_sdio_func_to_bus(struct sdio_func *func);
>  
>  struct ssb_freeze_context {
>  	/* Pointer to the bus */

To me this looked like an odd way to silence that warning. So I dug a
bit further.

ssb_sdio_func_to_bus() was added in commit 24ea602e183c ("ssb: Implement
SDIO host bus support"). So it was added in release v2.6.32. I found no
evidence this function was ever used. Can't it be removed?


Paul Bolle

