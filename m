Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaGBCwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 22:52:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:3968 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaGBCwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 22:52:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,586,1400050800"; 
   d="scan'208";a="563925325"
Message-ID: <53B373D2.7000306@intel.com>
Date: Wed, 02 Jul 2014 10:52:02 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>, chris@printf.net,
        ulf.hansson@linaro.org, jh80.chung@samsung.com, tgih.jun@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackey.shen@amd.com, gregkh@linuxfoundation.org
Subject: Re: one doubt about mmc_sdio_init_card function
References: <53B249A4.2040404@linux.intel.com>
In-Reply-To: <53B249A4.2040404@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 01:39 PM, Fu, Zhonghui wrote:
> 
> Hi, all
> 
> The mmc_sdio_init_card(drivers/mmc/core/sdio.c) function calls mmc_alloc_card(drivers/mmc/core/bus.c) function to allocate a card structure. card->dev.bus is assigned with mmc_bus_type in mmc_alloc_card function. Why not assign sdio_bus_type to card->dev.bus?

sdio card, mmc card, sd card are all devices on the mmc bus, hence their
bus type is set to mmc_bus_type.

sdio function device is a device on the sdio bus, hence its bus type is
sdio_bus_type.

Hope this helps,
Aaron

> 
> 
> struct mmc_card *mmc_alloc_card(struct mmc_host *host, struct device_type *type)
> {
>     struct mmc_card *card;
> 
>     card = kzalloc(sizeof(struct mmc_card), GFP_KERNEL);
>     if (!card)
>         return ERR_PTR(-ENOMEM);
> 
>     card->host = host;
> 
>     device_initialize(&card->dev);
> 
>     card->dev.parent = mmc_classdev(host);
>     card->dev.bus = &mmc_bus_type;
>     card->dev.release = mmc_release_card;
>     card->dev.type = type;
> 
>     return card;
> }
> 
> 
> Thanks,
> Zhonghui
> 

