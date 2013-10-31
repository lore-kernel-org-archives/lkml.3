Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3JaM3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:29:00 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:25181
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527Ab3JaM25 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:28:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h8e2h8e3h947hd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18deh18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Chen Guangyu-B42378 <B42378@freescale.com>
To: Timur Tabi <timur@tabi.org>
CC: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "philippe.retornaz@gmail.com" <philippe.retornaz@gmail.com>
Subject: Re: [PATCH v3 3/4] ASoC: fsl_ssi: Add dual fifo mode support
Thread-Topic: [PATCH v3 3/4] ASoC: fsl_ssi: Add dual fifo mode support
Thread-Index: AQHO1hLCD5WkQaYbh0645wKm66q9o5oOto6AgAAGzOI=
Date: Thu, 31 Oct 2013 12:28:49 +0000
Message-ID: <oxq6yw1a1g6ccnd85o4ral9y.1383222536476@email.android.com>
References: <cover.1383207153.git.b42378@freescale.com>
 <da997ce67d9817364248ca1eba716bb6c7814a24.1383207153.git.b42378@freescale.com>,<5272474D.5000207@tabi.org>
In-Reply-To: <5272474D.5000207@tabi.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the comments.
I'll refine this part.

Sent by Android device.

Timur Tabi <timur@tabi.org> wrote:


Nicolin Chen wrote:
> +     if (ssi_private->use_dual_fifo) {
> +             write_ssi_mask(&ssi->srcr, 0, CCSR_SSI_SRCR_RFEN1);
> +             write_ssi_mask(&ssi->stcr, 0, CCSR_SSI_STCR_TFEN1);
> +             write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_TCH_EN);
> +     } else {
> +             write_ssi_mask(&ssi->srcr, CCSR_SSI_SRCR_RFEN1, 0);
> +             write_ssi_mask(&ssi->stcr, CCSR_SSI_STCR_TFEN1, 0);
> +             write_ssi_mask(&ssi->scr, CCSR_SSI_SCR_TCH_EN, 0);
> +     }

Why do you need the "else" part?  Why can't you just do this:

if (ssi_private->use_dual_fifo) {
        write_ssi_mask(&ssi->srcr, 0, CCSR_SSI_SRCR_RFEN1);
        write_ssi_mask(&ssi->stcr, 0, CCSR_SSI_STCR_TFEN1);
        write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_TCH_EN);
}


