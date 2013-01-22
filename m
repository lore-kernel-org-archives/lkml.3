Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3AVDWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:22:01 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:47436
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab3AVDWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:22:00 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 22 Jan 2013 11:50:30 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 05/15] ASoC: fsl: fiq and dma cannot both be modules
Message-ID: <20130122035028.GB29677@S2100-06.ap.freescale.net>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1358788568-11137-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 05:15:58PM +0000, Arnd Bergmann wrote:
> The dma and fiq portions of the imx-pcm driver both
> have a module_init() call, of which there can be only
> one in any given module. This changes Kconfig to enforce
> either the driver to be built-in in the kernel, or
> to have only one of the two when building imx-pcm as
> a module.
> 
> Without this patch, we cannot build the ARM 'allmodconfig', or
> we get this error:
> 
> sound/soc/fsl/imx-pcm-dma.o: In function `init_module':
> sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `init_module'
> sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here
> sound/soc/fsl/imx-pcm-dma.o: In function `cleanup_module':
> sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `cleanup_module'
> sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: alsa-devel@alsa-project.org

I sent a fix [1] for that queued by Mark.

Mark,

Is the patch on the way to 3.8-rc?

Shawn

[1] http://thread.gmane.org/gmane.linux.alsa.devel/104434

