Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaGJWCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:02:44 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40587 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaGJWCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:02:36 -0400
Date: Thu, 10 Jul 2014 16:02:33 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Add include guard to include/linux/pci_ids.h
Message-ID: <20140710220233.GA21053@google.com>
References: <1404993911-10544-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404993911-10544-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 02:05:11PM +0200, Rasmus Villemoes wrote:
> Adding an include guard frees the preprocessor from reparsing over
> 2600 #defines in the cases where pci_ids.h is somehow included more
> than once. This gives a tiny-but-measurable performance improvement
> when compiling such files.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied to pci/misc for v3.17, thanks!

> ---
>  include/linux/pci_ids.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 7fa3173..6ed0bb7 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -6,6 +6,8 @@
>   *	Do not add new entries to this file unless the definitions
>   *	are shared between multiple drivers.
>   */
> +#ifndef _LINUX_PCI_IDS_H
> +#define _LINUX_PCI_IDS_H
>  
>  /* Device classes and subclasses */
>  
> @@ -2968,3 +2970,5 @@
>  #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
>  
>  #define PCI_VENDOR_ID_OCZ		0x1b85
> +
> +#endif /* _LINUX_PCI_IDS_H */
> -- 
> 1.9.2
> 
