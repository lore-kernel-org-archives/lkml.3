Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3EVAlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:41:22 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36265 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3EVAlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <1369176146-19383-6-git-send-email-peterhuewe@gmx.de>
References: <1369176146-19383-1-git-send-email-peterhuewe@gmx.de>
	<1369176146-19383-6-git-send-email-peterhuewe@gmx.de>
Date: Tue, 21 May 2013 17:41:20 -0700
Message-ID: <CAP6odjjq_yX7JCsBnTqKYh6E_FNjYBoxnMYFDRwj6Dcou14jwA@mail.gmail.com>
Subject: Re: [PATCH 06/19] net/ethernet/dec/tulip/xircom_cb: Use
 module_pci_driver to register driver
From: Grant Grundler <grantgrundler@gmail.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Grant Grundler <grundler@parisc-linux.org>,
        "open list:TULIP NETWORK DRI..." <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[new gmail editor changed how to send plaint/text email - sorry for
multiple copies]


On Tue, May 21, 2013 at 3:42 PM, Peter Huewe <peterhuewe@gmx.de> wrote:
> Removing some boilerplate by using module_pci_driver instead of calling
> register and unregister in the otherwise empty init/exit functions.
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

LGTM
Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
>  drivers/net/ethernet/dec/tulip/xircom_cb.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/xircom_cb.c b/drivers/net/ethernet/dec/tulip/xircom_cb.c
> index cdbcd16..9b84cb0 100644
> --- a/drivers/net/ethernet/dec/tulip/xircom_cb.c
> +++ b/drivers/net/ethernet/dec/tulip/xircom_cb.c
> @@ -1171,16 +1171,4 @@ investigate_write_descriptor(struct net_device *dev,
>         }
>  }
>
> -static int __init xircom_init(void)
> -{
> -       return pci_register_driver(&xircom_ops);
> -}
> -
> -static void __exit xircom_exit(void)
> -{
> -       pci_unregister_driver(&xircom_ops);
> -}
> -
> -module_init(xircom_init)
> -module_exit(xircom_exit)
> -
> +module_pci_driver(xircom_ops);
> --
> 1.8.1.5
>
