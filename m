Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3KSXni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:43:38 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:49960
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab3KSXnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:43:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h1155h)
Message-ID: <1384904608.1403.395.camel@snotra.buserror.net>
Subject: Re: [PATCH] lib/crc32: slice by 4 is more efficient than the
 default slice by 8 on Powerpc 8xx.
From: Scott Wood <scottwood@freescale.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
CC: Christophe Leroy <christophe.leroy@c-s.fr>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, Marcelo Tosatti <marcelo@kvack.org>,
        Bob Pearson <rpearson@systemfabricworks.com>
Date: Tue, 19 Nov 2013 17:43:28 -0600
In-Reply-To: <OFE596957E.9CEC5C97-ONC1257C28.00814EE8-C1257C28.0081FB80@transmode.se>
References: <20131118070423.E47181A4D3D@localhost.localdomain>
	 <OF5004EA63.AA9B7989-ONC1257C28.004D6C13-C1257C28.004DF922@transmode.se>
	 <1384885766.1403.366.camel@snotra.buserror.net>
	 <OFE596957E.9CEC5C97-ONC1257C28.00814EE8-C1257C28.0081FB80@transmode.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 00:39 +0100, Joakim Tjernlund wrote:
> Scott Wood <scottwood@freescale.com> wrote on 2013/11/19 19:29:26:
> > 
> > I don't think we should go littering the Kconfig with defaults for
> > various bits of hardware -- especially since you've already pointed out
> > non-8xx hardware that would also want this.  Put it in defconfig
> > instead, unless you can identify very broad classes of machines for
> > which SLICEBY4 is faster.
> 
> hmm, when 64bits went in there was not much proof that it was faster for
> a wide range of CPU, just 2 or 3 if I recall correctly. I suspect there
> are quite a few CPUs where 32 bits a equal or faster.

That may be the case, but I don't think we want a big list of them in
lib/Kconfig.  Whether the default should change (for all targets that
don't override it in defconfig, or at least for some broader category
such as "all 32-bit chips") is a different discussion.

-Scott



