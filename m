Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaLAQwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:52:03 -0500
Received: from muin.pair.com ([209.68.1.55]:55517 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbaLAQwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:52:00 -0500
Message-ID: <547C9CAD.1000008@tabi.org>
Date: Mon, 01 Dec 2014 10:51:57 -0600
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Markus Pargmann <mpa@pengutronix.de>,
        Jiada Wang <jiada_wang@mentor.com>
CC: alsa-devel@alsa-project.org, lgirdwood@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, nicoleotsuka@gmail.com, broonie@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <20141201065046.GB27289@pengutronix.de> <547C9C34.9080602@metafoo.de>
In-Reply-To: <547C9C34.9080602@metafoo.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 10:49 AM, Lars-Peter Clausen wrote:

> The driver creates the mapping by calling irq_of_parse_and_map(), so it
> also has to dispose the mapping. But the easy way out is to simply use
> platform_get_irq() instead of irq_of_parse_map(). In this case the
> mapping is not managed by the device but by the of core, so the device
> has not to dispose the mapping.

Is this a problem unique to the SSI driver?  Maybe devm_free_irq() 
should also dispose of the mapping?

