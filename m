Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaGAFj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:39:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:46911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaGAFj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:39:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,580,1400050800"; 
   d="scan'208";a="536939263"
Message-ID: <53B249A4.2040404@linux.intel.com>
Date: Tue, 01 Jul 2014 13:39:48 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: chris@printf.net, ulf.hansson@linaro.org, jh80.chung@samsung.com,
        tgih.jun@samsung.com, aaron.lu@intel.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jackey.shen@amd.com,
        gregkh@linuxfoundation.org
Subject: one doubt about mmc_sdio_init_card function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, all

The mmc_sdio_init_card(drivers/mmc/core/sdio.c) function calls mmc_alloc_card(drivers/mmc/core/bus.c) function to allocate a card structure. card->dev.bus is assigned with mmc_bus_type in mmc_alloc_card function. Why not assign sdio_bus_type to card->dev.bus?


struct mmc_card *mmc_alloc_card(struct mmc_host *host, struct device_type *type)
{
    struct mmc_card *card;

    card = kzalloc(sizeof(struct mmc_card), GFP_KERNEL);
    if (!card)
        return ERR_PTR(-ENOMEM);

    card->host = host;

    device_initialize(&card->dev);

    card->dev.parent = mmc_classdev(host);
    card->dev.bus = &mmc_bus_type;
    card->dev.release = mmc_release_card;
    card->dev.type = type;

    return card;
}


Thanks,
Zhonghui
