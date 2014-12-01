Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaLAUBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:01:51 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59463 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaLAUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:01:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@tabi.org>
Cc: linuxppc-dev@lists.ozlabs.org, Mark Brown <broonie@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        Jiada Wang <jiada_wang@mentor.com>, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, nicoleotsuka@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, Markus Pargmann <mpa@pengutronix.de>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
Date: Mon, 01 Dec 2014 21:01:43 +0100
Message-ID: <3401240.VsRpsiV8WN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <547CC89F.1030205@tabi.org>
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <2547588.Qc4F2IfZke@wuerfel> <547CC89F.1030205@tabi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zNmWa4uECF2+693o7jhWO4Go5h7JBaLzsgJy+t0CbZl
 T8HSH+MEiuYFNQDa+cY5AnqsAwgDzaqOBoC2oRXK8tAM5rk9Oc
 3US+3Pfj8P3hPHv6ki6M9KMKC75qhsE5AoY9V/4/PvaFiI5v4D
 GXNFehBvlJw/JVbJquZBRSYUm78sDCk4VQnn2KP2YC/R8PzEz1
 Eqi1CDCRfGR3hpnuTI/8FaW+QMA4EpcU/+3drkz0+bCbtGWyt5
 4w/Quiiyw7wSgpO2xW3E8GrsX+CzAjCOzXSww3n61RboAbtNga
 tTZAjc/M5ZSz62qPue5ArjVldwz1TiLjVpSc8CKRhLLSqHXcfI
 SIH4gLPHQAUx7Ov+DOeU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 13:59:27 Timur Tabi wrote:
> On 12/01/2014 01:56 PM, Arnd Bergmann wrote:
> > All other drivers that call irq_of_parse_and_map and pass that into
> > devm_request_irq just never unmap, and their interrupts are already
> > mapped by the platform code, so I think it's not even a leak.
> 
> Does this mean that fsl_ssi.c should not be calling 
> irq_of_parse_and_map?  How else should it get the IRQ?

platform_get_irq()

	Arnd
