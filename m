Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbaGPIl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:41:58 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56747 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbaGPIlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:41:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Wed, 16 Jul 2014 10:41:10 +0200
Message-ID: <42036198.zWkqnus6xa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405499166-6726-8-git-send-email-antoine.tenart@free-electrons.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <1405499166-6726-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:eNxj0ggy1y/RAZUFvWt0/H7JhUZ/ye1LjZrepP78UuS
 nCAj1ESeqscgF5WJarcwsxkiT0XfFAdg9RHq3pJEPv2FvfoxKQ
 1Hr1yva6dV9wjYbu84g3TAAd9UolheR7UmS3nLIgPCMYGPRz+A
 68TrxLalhALhrUVcPFPGAGpuaPy/KUUApDlILEmkJyQfG0DCSF
 OoP4zC7yLMeTKWF40llYrFyQ0lU3UpTxHwjwg9dpyF4dICSUCm
 Bf8AQaoLB/9c+4X1sxu3yoZgqGaow98WjanKwoNdrKCYlIUW4K
 lm31/dwgvwiRSKRxwnwj44z5YeM7KGkGUQ1ORqXz3czmtxXBoT
 z1KTewZcbbUlYLv4m0is=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 10:26:01 Antoine Ténart wrote:
> +
> +       if (priv->dma_mask) {
> +               ret = dma_coerce_mask_and_coherent(&pdev->dev, priv->dma_mask);
> +               if (ret)
> +                       return ret;
> +       }
> +
> 

As mentioned in my comment for the binding, this is the wrong way to do it.
Russell has in the past converted all drivers that did this manually to 
do dma_coerce_mask_and_coherent() so we can spot them more easily, but we
should really be doing this better for new drivers.

Can you describe what the restriction is that you want to put on the dma mask?

	Arnd
