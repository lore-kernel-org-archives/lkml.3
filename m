Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3I0VoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:44:00 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:52472
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620Ab3I0Vn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:43:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI154dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380318232.24959.495.camel@snotra.buserror.net>
Subject: Re: [PATCH v4] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 27 Sep 2013 16:43:52 -0500
In-Reply-To: <201309240818.r8O8IdF9016374@localhost.localdomain>
References: <201309240818.r8O8IdF9016374@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 10:18 +0200, Christophe Leroy wrote:
> Activating CONFIG_PIN_TLB is supposed to pin the IMMR and the first three
> 8Mbytes pages. But the setting of MD_CTR to a pinnable entry was missing before
> the pinning of the third 8Mb page. As the index is decremented module 28
> (MD_RSV4D is set) after every DTLB update, the third 8Mbytes page was
> not pinned.

The examples you showed weren't quite modulo 28, more like "if (x >= 28)
x -= 4".  I'll fix up the changelog on applying, to read something like
"As the index is decremented to a value within the first 28 entries
(MD_RSV4D is set)...".

-Scott



