Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3AYVLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:11:35 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:55350 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab3AYVLd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:11:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Date: Fri, 25 Jan 2013 13:03:30 -0800
Subject: RE: [PATCH] mwifiex: don't return zero on failure paths in
 mwifiex_pcie_init()
Thread-Topic: [PATCH] mwifiex: don't return zero on failure paths in
 mwifiex_pcie_init()
Thread-Index: Ac37Pmq90Q+x5G7uQaie990FNqXvTwAANFJw
Message-ID: <477F20668A386D41ADCC57781B1F70430D1418CA15@SC-VEXCH1.marvell.com>
References: <1359147363-9587-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1359147363-9587-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

Thanks for the patch.

> If pci_iomap() fails in mwifiex_pcie_init(), it breaks off initialization,
> deallocates all resources, but returns zero.
> The patch adds -EIO as return value in this case.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/pcie.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index 13fbc4e..9d9349c 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -1739,6 +1739,7 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
>  	card->pci_mmap = pci_iomap(pdev, 0, 0);
>  	if (!card->pci_mmap) {
>  		dev_err(adapter->dev, "iomap(0) error\n");
> +		ret = -EIO;
>  		goto err_iomap0;
>  	}
>  	ret = pci_request_region(pdev, 2, DRV_NAME);
> @@ -1749,6 +1750,7 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
>  	card->pci_mmap1 = pci_iomap(pdev, 2, 0);
>  	if (!card->pci_mmap1) {
>  		dev_err(adapter->dev, "iomap(2) error\n");
> +		ret = -EIO;
>  		goto err_iomap2;
>  	}
> 
> --
> 1.7.9.5

