Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaBDScU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:32:20 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26021 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaBDScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:32:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7338"; a="58901504"
X-IronPort-AV: E=McAfee;i="5400,1158,7338"; a="678649495"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
References: <cover.1389904166.git.agordeev@redhat.com>
	<ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
	<20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
Date: Tue, 4 Feb 2014 20:32:12 +0200
In-Reply-To: <20140130134819.GA31909@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Thu, 30 Jan 2014 14:48:20 +0100")
Message-ID: <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 29fd197..6525e1f 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -2414,8 +2414,6 @@ static int ath10k_pci_init_irq(struct ath10k *ar)
>  		ret = pci_enable_msi_block(ar_pci->pdev, ar_pci->num_msi_intrs);
>  		if (ret == 0)
>  			return 0;
> -		if (ret > 0)
> -			pci_disable_msi(ar_pci->pdev);

I don't understand how this is superfluous. When I read the
documentation for pci_enable_msi_block() it states that if it can't
allocate all requests, it will return the number requests it could
allocate. And in that case we want to fall back other modes.

Am I missing something?

-- 
Kalle Valo
