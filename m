Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaLAT7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:59:31 -0500
Received: from muin.pair.com ([209.68.1.55]:53385 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbaLAT7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:59:30 -0500
Message-ID: <547CC89F.1030205@tabi.org>
Date: Mon, 01 Dec 2014 13:59:27 -0600
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
CC: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, Jiada Wang <jiada_wang@mentor.com>,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        nicoleotsuka@gmail.com, tiwai@suse.de, Li.Xiubo@freescale.com,
        Markus Pargmann <mpa@pengutronix.de>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <547CC407.30308@metafoo.de> <20141201194147.GP7712@sirena.org.uk> <2547588.Qc4F2IfZke@wuerfel>
In-Reply-To: <2547588.Qc4F2IfZke@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 01:56 PM, Arnd Bergmann wrote:
> All other drivers that call irq_of_parse_and_map and pass that into
> devm_request_irq just never unmap, and their interrupts are already
> mapped by the platform code, so I think it's not even a leak.

Does this mean that fsl_ssi.c should not be calling 
irq_of_parse_and_map?  How else should it get the IRQ?
