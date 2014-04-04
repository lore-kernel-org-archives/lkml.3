Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaDDPKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:10:17 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:48360
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaDDPKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:10:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I1447Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz17326ah8275dh1de097h186068hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Fri, 4 Apr 2014 23:09:59 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Inconsistent lock state introduced by ipv6/addrconf change
Message-ID: <20140404150958.GB16383@dragon>
References: <20140404073455.GB29778@dragon>
 <20140404114848.GD13354@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140404114848.GD13354@order.stressinduktion.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 01:48:48PM +0200, Hannes Frederic Sowa wrote:
> Hello!
> 
> On Fri, Apr 04, 2014 at 03:34:56PM +0800, Shawn Guo wrote:
> > I'm running into an inconsistent lock state warning on the final v3.14
> > kernel (-rc8 is good) on Freescale i.MX6 platform with fec driver
> > (drivers/net/ethernet/freescale/fec_main.c).  The git bisect points
> > the finger to commit c15b1cc (ipv6: move DAD and addrconf_verify
> > processing to workqueue).  Reverting the commit does fix the problem
> > for me.  The image is built from arch/arm/configs/imx_v6_v7_defconfig.
> > 
> > The interesting part is the same warning shows up on mainline tree until
> > net-next gets merged with commit cd6362b.  That's why Olof's autobooter
> > keeps reporting failure on hummingboard and wandboard (both i.MX6 based)
> > since v3.14 release [1], but reports success after commit cd6362b.
> > 
> > We're less concerned by the mainline tree, since the problem disappeared
> > now (nice to know why though).  But we do still want to fix it for 3.14
> > stable kernel.
> 
> The patch which fixes this is already queued up for -stable:
> 
> http://patchwork.ozlabs.org/patch/335536/

Thanks for the pointer.

Shawn

