Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3BGEiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:38:54 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:4326 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472Ab3BGEiw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:38:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5hbe9i1155h)
From: Garg Vakul-B16394 <B16394@freescale.com>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Liu Shengzhou-B36685 <B36685@freescale.com>,
        Porosanu Alexandru-B06830 <B06830@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: caam - set RDB bit in security configuration
 register
Thread-Topic: [PATCH] crypto: caam - set RDB bit in security configuration
 register
Thread-Index: AQHOBNN3tWVoB0b4XkSW8TLLUXy5Bphtz9Ig
Date: Thu, 7 Feb 2013 04:38:46 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B9417E955@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1360151266-28428-1-git-send-email-vakul@freescale.com>
 <20130206193315.cb27accf9a7a7f95870fb47f@freescale.com>
In-Reply-To: <20130206193315.cb27accf9a7a7f95870fb47f@freescale.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.28]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Phillips Kim-R1AAHA
> Sent: Thursday, February 07, 2013 7:03 AM
> To: Garg Vakul-B16394
> Cc: linux-crypto@vger.kernel.org; Herbert Xu; David S. Miller; Liu
> Shengzhou-B36685; Porosanu Alexandru-B06830; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] crypto: caam - set RDB bit in security configuration
> register
> 
> On Wed, 6 Feb 2013 17:17:46 +0530
> Vakul Garg <vakul@freescale.com> wrote:
> 
> > This change is required for post SEC-5.0 devices which have RNG4.
> > Setting RDB
> 
> wrap your commit message text to 75 chars
Ok 


> 
> > in security configuration register allows CAAM to use the "Random Data
> Buffer"
> > to be filled by a single request. The Random Data Buffer is large
> > enough for ten packets to get their IVs from a single request. If the
> > Random Data Buffer is not enabled, then each IV causes a separate
> > request, and RNG4 hardware cannot keep up resulting in lower IPSEC
> throughput.
> 
> Linux kernel IPSec or another IPSEC stack?  how much lower?

We measured USDPAA IPSEC throughput to be 1.9 times better on T4240 with this change.

> 
> > +	if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
> > +		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
> > +
> 
> this belongs further down - at the end of the RNG4 initialization
> section.

Ok

> 
> Kim

