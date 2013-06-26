Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3FZQTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:19:37 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:48761 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3FZQTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <51CA5829.9060807@asianux.com>
References: <51CA5829.9060807@asianux.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Jun 2013 10:19:14 -0600
Message-ID: <CAErSpo4dg7cVN1grEuKWvDJkZoJPAaELeh8knqD=s-nd5dsBNw@mail.gmail.com>
Subject: Re: [PATCH] arch: frv: mb93090-mb00: remove '__init' for
 pci_fixup_umc_ide() which used by 'DECLARE_PCI_FIXUP_HEADER'
To: Chen Gang <gang.chen@asianux.com>
Cc: "dhowells@redhat.com" <dhowells@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 8:55 PM, Chen Gang <gang.chen@asianux.com> wrote:
> pci_fixup_umc_ide() is for 'DECLARE_PCI_FIXUP_HEADER', so need remove
> it from init section to normal section.
>
> The related warning (with allmodconfig):
>
>   LD      arch/frv/mb93090-mb00/built-in.o
> WARNING: arch/frv/mb93090-mb00/built-in.o(.pci_fixup_header+0x4c): Section mismatch in reference from the variable __pci_fixup_PCI_VENDOR_ID_UMCPCI_DEVICE_ID_UMC_UM8886BFpci_fixup_umc_ide to the function .init.text:pci_fixup_umc_ide()
> The variable __pci_fixup_PCI_VENDOR_ID_UMCPCI_DEVICE_ID_UMC_UM8886BFpci_fixup_umc_ide references
> a function __init pci_fixup_umc_ide().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __init annotation of
> pci_fixup_umc_ide() so it may be used outside an exit section.
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  arch/frv/mb93090-mb00/pci-vdk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
> index 0aa35f0..56a3abf 100644
> --- a/arch/frv/mb93090-mb00/pci-vdk.c
> +++ b/arch/frv/mb93090-mb00/pci-vdk.c
> @@ -254,7 +254,7 @@ static void __init pcibios_fixup_peer_bridges(void)
>   * Exceptions for specific devices. Usually work-arounds for fatal design flaws.
>   */
>
> -static void __init pci_fixup_umc_ide(struct pci_dev *d)
> +static void pci_fixup_umc_ide(struct pci_dev *d)
>  {
>         /*
>          * UM8886BF IDE controller sets region type bits incorrectly,
> --
> 1.7.7.6
