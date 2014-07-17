Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbaGQLuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:50:17 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:48870 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaGQLuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:50:14 -0400
MIME-Version: 1.0
In-Reply-To: <1405596653.770128886@apps.rackspace.com>
References: <1405596653.770128886@apps.rackspace.com>
Date: Thu, 17 Jul 2014 17:20:10 +0530
Message-ID: <CABu_nUQTu1_+sQ_Wkm1R=mOKtCP7GMcie7RJefGL=O6nOYyZrA@mail.gmail.com>
Subject: Re: FW: Fwd: [RFC PATCH] mmc: mmci: Add qcom dml support to the driver.
From: Prakash Burla <burlaprakash.linuxkernel@gmail.com>
To: srinivas.kandagatla@linaro.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, chris@printf.net,
        ulf.hansson@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested-by: Prakash Burla <prakash.burla@smartplayin.com>
This driver is tested on IFC6410.

>
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Date: Fri, Jul 11, 2014 at 5:18 PM
> Subject: [RFC PATCH] mmc: mmci: Add qcom dml support to the driver.
> To: linux-mmc@vger.kernel.org
> Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball
> <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>, Russell King
> <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org, Srinivas
> Kandagatla <srinivas.kandagatla@linaro.org>
>
>
> On Qualcomm APQ8064 SOCs, SD card controller has an additional glue
> called DML (Data Mover Local/Lite) to assist dma transfers.
> This hardware needs to be setup before any dma transfer is requested.
> DML itself is not a DMA engine, its just a gule between the SD card
> controller and dma controller.
>
> Most of this code has been ported from qualcomm's 3.4 kernel.
>
> This patch adds the code necessary to intialize the hardware and setup
> before doing any dma transfers.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>
> Hi All,
>
> DMA support for Qualcomm SD card controller is missing in my last patchset, the
> reason to post this patch separately is because of the unusual glue logic
> between card controller and the dma-controller. This glue logic is called DML
> (Data mover local/lite).
>
> DML assists dma transfers between sd card controller and dma-controller. As this
> DML gule is part of SD controller IP and needs configuring for every transfer,
> So I thought of keeping it close to driver in drivers/mmc/ directory is more
> usefull, than trying to find a infrastructure to fit it. DML itself is not a DMA
> controller but an logic present on SD card controller and it resides in SD card
> controller IP.
>
> I would like to get your opnion on overall correctness of the approch.
>
> Thanks in advance.
> srini
>
>
>  drivers/mmc/host/Kconfig    |  11 +++
>  drivers/mmc/host/Makefile   |   1 +
>  drivers/mmc/host/mmci.c     |  19 ++++-
>  drivers/mmc/host/qcom_dml.c | 171 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/host/qcom_dml.h |  17 +++++
>  5 files changed, 218 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mmc/host/qcom_dml.c
>  create mode 100644 drivers/mmc/host/qcom_dml.h
>
.
[SNIP]
.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
