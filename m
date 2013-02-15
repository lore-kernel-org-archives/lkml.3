Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab3BOSx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:53:58 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54176 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3BOSx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:53:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130214183438.16138.15416.stgit@bling.home>
References: <20130214183438.16138.15416.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 15 Feb 2013 11:53:36 -0700
Message-ID: <CAErSpo7GGVSE2KmNK+e4ObDZij95ZzWDuZL3UGk3RVrDg-EkFQ@mail.gmail.com>
Subject: Re: [PATCH] pci: Fix pcie access for PCI_EXP_FLAGS
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiang.liu@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:35 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> PCI_EXP_FLAGS_TYPE is a mask, not an offset.  Fix it.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

I applied this to pci/misc so it will appear in v3.9 and marked it for
stable for v3.7+.

Thanks!

> ---
>  drivers/pci/access.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/access.c b/drivers/pci/access.c
> index 3af0478..32046c5 100644
> --- a/drivers/pci/access.c
> +++ b/drivers/pci/access.c
> @@ -515,7 +515,7 @@ static bool pcie_capability_reg_implemented(struct pci_dev *dev, int pos)
>                 return false;
>
>         switch (pos) {
> -       case PCI_EXP_FLAGS_TYPE:
> +       case PCI_EXP_FLAGS:
>                 return true;
>         case PCI_EXP_DEVCAP:
>         case PCI_EXP_DEVCTL:
>
