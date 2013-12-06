Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3LFTKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:10:11 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:3545 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900Ab3LFTKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:10:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI936eIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386356996.7375.120.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc 8xx: Loading kernels over 8Mbytes without
 CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Fri, 6 Dec 2013 13:09:56 -0600
In-Reply-To: <20131127110406.6DC8E1A504F@localhost.localdomain>
References: <20131127110406.6DC8E1A504F@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-27 at 12:04 +0100, Christophe Leroy wrote:
> Today, the only way to load kernels whose size is greater than 8Mbytes is to
> activate CONFIG_PIN_TLB. Otherwise, the physical memory initially mapped is
> limited to 8Mbytes. This patch sets up 24 Mbytes of initial memory regardless
> of whether CONFIG_PIN_TLB is active or not. It allows to load "big" kernels
> (for instance when activating CONFIG_LOCKDEP_SUPPORT) without having
> to activate CONFIG_PIN_TLB.

So, what happens on boards with less than 24M memory present?  Even if
you avoid explicitly referencing those addresses, what if there is a
speculative access -- or does 8xx not do that?

-Scott



