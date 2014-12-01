Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaLAQty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:49:54 -0500
Received: from smtp-out-248.synserver.de ([212.40.185.248]:1210 "EHLO
	smtp-out-248.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaLAQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:49:52 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12250
Message-ID: <547C9C34.9080602@metafoo.de>
Date: Mon, 01 Dec 2014 17:49:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Markus Pargmann <mpa@pengutronix.de>, Jiada Wang <jiada_wang@mentor.com>
CC: alsa-devel@alsa-project.org, lgirdwood@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, timur@tabi.org, nicoleotsuka@gmail.com,
        broonie@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <20141201065046.GB27289@pengutronix.de>
In-Reply-To: <20141201065046.GB27289@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 07:50 AM, Markus Pargmann wrote:
[...]
>
> devm_request_irq() is used by other drivers too, this should not be a
> problem. Looking at the code it seems that irq_dispose_mapping may not
> be necessary with devm_request_irq(). So I think it would be better to
> remove irq_dispose_mapping() instead.

The driver creates the mapping by calling irq_of_parse_and_map(), so it also 
has to dispose the mapping. But the easy way out is to simply use 
platform_get_irq() instead of irq_of_parse_map(). In this case the mapping 
is not managed by the device but by the of core, so the device has not to 
dispose the mapping.

- Lars
