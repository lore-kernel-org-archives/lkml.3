Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaIWKjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:39:55 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:65030 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaIWKjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:39:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Tue, 23 Sep 2014 12:39:04 +0200
Message-ID: <2909480.SL9c0XWUbW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Qn0M2LnjT4UDIsFn9CsdH2KtILRIHIzrkHssBiUkrfx
 MxeZ6kB5+NxabjQUKv0xckvgYSALJuC5Zn9QJ02TWVTYJ0moA9
 3nMV+SmvyZEmrLRQI9hAOv6wczP0pubPfbTL6z8CAeP060H+Hh
 LATOMMidobpzzVjGoDu1NkGfMQFEsAC5LGV8UaNIpoccLXK9hf
 occTW3kX9mfIMPaVg3NUSaMIoHxYqDJsC/GHMhy39Nh5O+DoaW
 9KFY57WY4xvBUcwl8LxO6GcIArR2EbUTI9icBr7nav96JityM1
 Zv8qSK1HLZiN8rhRjc6m+CATmMsEr7AYSOWGZm2fvm391OXJWG
 zYaBYCcVOwExqFkF4Smg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 12:28:03 Antoine Tenart wrote:
> +       if (dev->of_node) {
> +               ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> +               if (ret)
> +                       goto clk_err;
> +       } else {
> +               ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +               if (ret)
> +                       goto clk_err;
> +       }
> 

Why do you care about the non-DT case here? I think it would be nicer to
open-code the ci_hdrc_usb2_dt_probe() function in here and remove
the dma_set_mask_and_coherent(), which should not even be necessary for
the case where you have a hardwired platform device.

	Arnd
