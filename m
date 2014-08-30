Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaH3NHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 09:07:34 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:65057 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaH3NHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 09:07:32 -0400
MIME-Version: 1.0
In-Reply-To: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
References: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
Date: Sat, 30 Aug 2014 10:07:30 -0300
Message-ID: <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
Subject: Re: [PATCH] Export functions from pcie-designware
From: Fabio Estevam <festevam@gmail.com>
To: matwey@sai.msu.ru
Cc: Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, matwey.kornilov@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 9:24 AM,  <matwey@sai.msu.ru> wrote:
> From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
>
> pcie-spear13xx when built as module requires the functions from pcie-designware.
> Export them properly.
>
> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> ---
>  drivers/pci/host/pcie-designware.c |  7 +++++++
>  drivers/pci/host/pcie-designware.h | 14 +++++++-------
>  2 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 52bd3a1..7914b92c 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -89,6 +89,7 @@ int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val)
>
>         return PCIBIOS_SUCCESSFUL;
>  }
> +EXPORT_SYMBOL(dw_pcie_cfg_read);

What about using EXPORT_SYMBOL_GPL instead?

> -int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> -int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val);
> -irqreturn_t dw_handle_msi_irq(struct pcie_port *pp);
> -void dw_pcie_msi_init(struct pcie_port *pp);
> -int dw_pcie_link_up(struct pcie_port *pp);
> -void dw_pcie_setup_rc(struct pcie_port *pp);
> -int dw_pcie_host_init(struct pcie_port *pp);
> +extern int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> +extern int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val);
> +extern irqreturn_t dw_handle_msi_irq(struct pcie_port *pp);
> +extern void dw_pcie_msi_init(struct pcie_port *pp);
> +extern int dw_pcie_link_up(struct pcie_port *pp);
> +extern void dw_pcie_setup_rc(struct pcie_port *pp);
> +extern int dw_pcie_host_init(struct pcie_port *pp);

Why is this needed?
