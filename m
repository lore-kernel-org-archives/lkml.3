Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3BGBf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:35:59 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:8115 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab3BGBf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:35:57 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Wed, 6 Feb 2013 19:33:15 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Vakul Garg <vakul@freescale.com>
CC: <linux-crypto@vger.kernel.org>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Alex Porosanu <alexandru.porosanu@freescale.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - set RDB bit in security configuration
 register
Message-ID: <20130206193315.cb27accf9a7a7f95870fb47f@freescale.com>
In-Reply-To: <1360151266-28428-1-git-send-email-vakul@freescale.com>
References: <1360151266-28428-1-git-send-email-vakul@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013 17:17:46 +0530
Vakul Garg <vakul@freescale.com> wrote:

> This change is required for post SEC-5.0 devices which have RNG4. Setting RDB

wrap your commit message text to 75 chars

> in security configuration register allows CAAM to use the "Random Data Buffer"
> to be filled by a single request. The Random Data Buffer is large enough for
> ten packets to get their IVs from a single request. If the Random Data Buffer
> is not enabled, then each IV causes a separate request, and RNG4 hardware
> cannot keep up resulting in lower IPSEC throughput.

Linux kernel IPSec or another IPSEC stack?  how much lower?

> +	if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
> +		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
> +

this belongs further down - at the end of the RNG4 initialization
section.

Kim

