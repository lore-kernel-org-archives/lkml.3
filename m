Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3E0XHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 19:07:09 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53850 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab3E0XHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 19:07:06 -0400
MIME-Version: 1.0
In-Reply-To: <1369621733-20048-1-git-send-email-libo.chen@huawei.com>
References: <1369621733-20048-1-git-send-email-libo.chen@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 May 2013 17:06:46 -0600
Message-ID: <CAErSpo6MYJ6+5jy8AoDB6v_ZkxmjymsyrP6JgFRt9O-GeFf=Gg@mail.gmail.com>
Subject: Re: [PATCH 09/24] drivers/pci/ioapic: Convert to module_pci_driver
To: Libo Chen <libo.chen@huawei.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 8:28 PM, Libo Chen <libo.chen@huawei.com> wrote:
> use module_pci_driver instead of init/exit, make code clean.
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/pci/ioapic.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)

Applied to my pci/misc branch for v3.11, thanks!

> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> index 3c6bbdd..1b90579 100644
> --- a/drivers/pci/ioapic.c
> +++ b/drivers/pci/ioapic.c
> @@ -113,17 +113,6 @@ static struct pci_driver ioapic_driver = {
>         .remove         = ioapic_remove,
>  };
>
> -static int __init ioapic_init(void)
> -{
> -       return pci_register_driver(&ioapic_driver);
> -}
> -
> -static void __exit ioapic_exit(void)
> -{
> -       pci_unregister_driver(&ioapic_driver);
> -}
> -
> -module_init(ioapic_init);
> -module_exit(ioapic_exit);
> +module_pci_driver(ioapic_driver);
>
>  MODULE_LICENSE("GPL");
> --
> 1.7.1
>
>
