Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3EVAXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:23:08 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2407 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab3EVAXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:23:06 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <519C0FD8.80705@broadcom.com>
Date: Tue, 21 May 2013 17:22:48 -0700
From: "Nithin Nayak Sujir" <nsujir@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Peter Huewe" <peterhuewe@gmx.de>
cc: "David S. Miller" <davem@davemloft.net>,
        "Michael Chan" <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/19] net/ethernet/broadcom/tg3: Use
 module_pci_driver to register driver
References: <1369176146-19383-1-git-send-email-peterhuewe@gmx.de>
 <1369177096-19674-11-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369177096-19674-11-git-send-email-peterhuewe@gmx.de>
X-WSS-ID: 7D82D08631W24420597-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/21/2013 03:58 PM, Peter Huewe wrote:
> Removing some boilerplate by using module_pci_driver instead of calling
> register and unregister in the otherwise empty init/exit functions.
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>   drivers/net/ethernet/broadcom/tg3.c | 13 +------------
>   1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index fb06aa1..4f0e3fe 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -17804,15 +17804,4 @@ static struct pci_driver tg3_driver = {
>   	.driver.pm	= &tg3_pm_ops,
>   };
>
> -static int __init tg3_init(void)
> -{
> -	return pci_register_driver(&tg3_driver);
> -}
> -
> -static void __exit tg3_cleanup(void)
> -{
> -	pci_unregister_driver(&tg3_driver);
> -}
> -
> -module_init(tg3_init);
> -module_exit(tg3_cleanup);
> +module_pci_driver(tg3_driver);
>

Acked-by: Nithin Nayak Sujir <nsujir@broadcom.com>

