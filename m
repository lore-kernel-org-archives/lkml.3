Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaCFK6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:58:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43107 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbaCFK63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:58:29 -0500
Date: Thu, 6 Mar 2014 11:58:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nick Krause <nickkrause@sympatico.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: Re: Patch[Kernel 3.13.5]
Message-ID: <20140306105821.GA24636@pd.tnic>
References: <SNT145-W1141791FC5F60B7E0788170A5880@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SNT145-W1141791FC5F60B7E0788170A5880@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 04:00:04AM +0000, Nick Krause wrote:
> Here is my first patch, adding a break point to fix bug 60845, case fallout through on switch 
> in arch/mips/pci/msi-octeon.c.
> 
> --- //home/nick/linux-3.13.5/arch/mips/pci/msi-octeon.c.orig    2014-03-05 22:48:19.084372515 -0500
> +++ //home/nick/linux-3.13.5/arch/mips/pci/msi-octeon.c    2014-03-05 22:48:48.388372344 -0500
> @@ -150,6 +150,7 @@ msi_irq_allocated:
>          msg.address_lo =
>              ((128ul << 20) + CVMX_PCI_MSI_RCV) & 0xffffffff;
>          msg.address_hi = ((128ul << 20) + CVMX_PCI_MSI_RCV)>> 32;
> +        break;
>      case OCTEON_DMA_BAR_TYPE_BIG:
>          /* When using big bar, Bar 0 is based at 0 */
>          msg.address_lo = (0 + CVMX_PCI_MSI_RCV) & 0xffffffff;
> Got one error no maintainer otherwise not issues with coding style.

Looks like a real bug you've found, as e8635b484f644 still has the
"break" in there.

However, if you want to learn how to prepare patches properly, take a
look at Documentation/SubmittingPatches.

There it also says how to find out who exactly to send this patch to:

$ ./scripts/get_maintainer.pl -f arch/mips/pci/msi-octeon.c
Ralf Baechle <ralf@linux-mips.org> (supporter:MIPS)
linux-mips@linux-mips.org (open list:MIPS)

I've CCed them.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
