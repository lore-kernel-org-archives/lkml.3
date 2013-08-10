Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3HJLzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 07:55:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46613 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757796Ab3HJLzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 07:55:05 -0400
Date: Sat, 10 Aug 2013 07:55:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Daney <ddaney.cavm@gmail.com>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2] usb: Move definition of USB_EHCI_BIG_ENDIAN_MMIO et
 al. out side of the ifs.
In-Reply-To: <1376097468-8531-1-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1308100754400.31571-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> When CONFIG_USB_SUPPORT is not selected we get things like:
> 
> scripts/kconfig/mconf Kconfig
> warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB)
> 
> It is much cleaner to make the various system Kconfigs select
> USB_EHCI_BIG_ENDIAN_MMIO rather than move the system config
> information into USB's Kconfig, but the warnings are annoying.
> 
> Eliminate the warning by moving the definition of
> USB_EHCI_BIG_ENDIAN_MMIO outside of all the Kconfig if statements.
> While we are at it move USB_OHCI_BIG_ENDIAN_DESC,
> USB_OHCI_BIG_ENDIAN_MMIO, USB_OHCI_LITTLE_ENDIAN and
> USB_EHCI_BIG_ENDIAN_DESC too, as they could very well suffer similar
> problems for other systems.
> 
> Get rid of the redundant "default n" in USB_OHCI_BIG_ENDIAN_DESC and
> USB_OHCI_BIG_ENDIAN_MMIO
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
> 
> Change from v1: Added USB_OHCI_BIG_ENDIAN_DESC,
> USB_OHCI_BIG_ENDIAN_MMIO, USB_OHCI_LITTLE_ENDIAN and
> USB_EHCI_BIG_ENDIAN_DESC to the set of symbols moved.

Acked-by: Alan Stern <stern@rowland.harvard.edu>


