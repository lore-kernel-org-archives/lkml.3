Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaAUUrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:47:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:29735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaAUUrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:47:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="442464612"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ixgbevf: delete unneeded call to pci_set_power_state
Thread-Topic: [PATCH] ixgbevf: delete unneeded call to pci_set_power_state
Thread-Index: AQHPFun5reSYbpjPtU6E4rQdUZwjyQ==
Date: Tue, 21 Jan 2014 20:47:17 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7314262D@ORSMSX101.amr.corp.intel.com>
References: <1389114026-27854-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1389114026-27854-1-git-send-email-Julia.Lawall@lip6.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0LKlU7q012414

On Tue, 2014-01-07 at 18:00 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> This driver does not need to adjust the power state on suspend, so the
> call to pci_set_power_state in the resume function is a no-op.  Drop it, to
> make the code more understandable.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Aaron Brown <aaron.f.brown@intel.com>

> ---
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index a5d3167..5709fb0 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -3226,7 +3226,6 @@ static int ixgbevf_resume(struct pci_dev *pdev)
>  	struct net_device *netdev = adapter->netdev;
>  	u32 err;
>  
> -	pci_set_power_state(pdev, PCI_D0);
>  	pci_restore_state(pdev);
>  	/*
>  	 * pci_restore_state clears dev->state_saved so call
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
