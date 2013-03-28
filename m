Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3C1BP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:15:26 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:27489
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571Ab3C1BPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:15:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 28 Mar 2013 09:15:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        <kernel@pengutronix.de>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v9 RESEND 3/4] media: coda: use genalloc API
Message-ID: <20130328011511.GA5429@S2101-09.ap.freescale.net>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
 <1363776767-2635-4-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363776767-2635-4-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:52:46AM +0100, Philipp Zabel wrote:
> This patch depends on "genalloc: add devres support, allow to find
> a managed pool by device", which provides the of_get_named_gen_pool
> and dev_get_gen_pool functions.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-By: Javier Martin <javier.martin@vista-silicon.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  Documentation/devicetree/bindings/media/coda.txt |   30 +++++++++++++++
>  drivers/media/platform/Kconfig                   |    1 -
>  drivers/media/platform/coda.c                    |   45 +++++++++++++++-------
>  include/linux/platform_data/coda.h               |   18 +++++++++
>  4 files changed, 79 insertions(+), 15 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/coda.txt
>  create mode 100644 include/linux/platform_data/coda.h
> 
> diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
> new file mode 100644
> index 0000000..2865d04
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/coda.txt
> @@ -0,0 +1,30 @@
> +Chips&Media Coda multi-standard codec IP
> +========================================
> +
> +Coda codec IPs are present in i.MX SoCs in various versions,
> +called VPU (Video Processing Unit).
> +
> +Required properties:
> +- compatible : should be "fsl,<chip>-src" for i.MX SoCs:

fsl,<chip>-vpu

Shawn

> +  (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
> +  (b) "fsl,imx53-vpu" for CODA7541 present in i.MX53
> +  (c) "fsl,imx6q-vpu" for CODA960 present in i.MX6q

