Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaAMQYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:24:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53960 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaAMQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:24:08 -0500
Date: Mon, 13 Jan 2014 16:24:02 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Timo Teras <timo.teras@iki.fi>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Pravin B Shelar <pshelar@nicira.com>,
        Timo Teras <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.11 180/208] ip_gre: fix msg_name parsing for
 recvfrom/recvmsg
Message-ID: <20140113162402.GC3340@hercules>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
 <1389628849-1614-181-git-send-email-luis.henriques@canonical.com>
 <20140113181022.2ae546af@vostro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140113181022.2ae546af@vostro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding back missing CC:)

On Mon, Jan 13, 2014 at 06:10:22PM +0200, Timo Teras wrote:
> On Mon, 13 Jan 2014 16:00:21 +0000
> Luis Henriques <luis.henriques@canonical.com> wrote:
> 
> > 3.11.10.3 -stable review patch.  If anyone has any objections, please
> > let me know.
> 
> Does it build? Seems you have missed the hunk to the headers that
> implement skb_pop_mac_header().

Well, it does build because patch:

 [PATCH 3.11 178/208] ipv6: fix illegal mac_header comparison on 32bit

actually added that hunk.  This is a fix that is stable-specific (not in
mainline).  Also, I've used David's stable patches for 3.10 as a base for
this patch.

Maybe this was a mistake as skb_pop_mac_header() doesn't seem to be
required by patch 178 in this serie...?

Cheers,
--
Luis

> > 
> > ------------------
> > 
> > From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>
> > 
> > commit 0e3da5bb8da45890b1dc413404e0f978ab71173e upstream.
> > 
> > ipgre_header_parse() needs to parse the tunnel's ip header and it
> > uses mac_header to locate the iphdr. This got broken when gre
> > tunneling was refactored as mac_header is no longer updated to point
> > to iphdr. Introduce skb_pop_mac_header() helper to do the mac_header
> > assignment and use it in ipgre_rcv() to fix msg_name parsing.
> > 
> > Bug introduced in commit c54419321455 (GRE: Refactor GRE tunneling
> > code.)
> > 
> > Cc: Pravin B Shelar <pshelar@nicira.com>
> > Signed-off-by: Timo Teräs <timo.teras@iki.fi>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > ---
> >  net/ipv4/ip_gre.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > index 8d6939e..2977400 100644
> > --- a/net/ipv4/ip_gre.c
> > +++ b/net/ipv4/ip_gre.c
> > @@ -217,6 +217,7 @@ static int ipgre_rcv(struct sk_buff *skb, const
> > struct tnl_ptk_info *tpi) iph->saddr, iph->daddr, tpi->key);
> >  
> >  	if (tunnel) {
> > +		skb_pop_mac_header(skb);
> >  		ip_tunnel_rcv(tunnel, skb, tpi, log_ecn_error);
> >  		return PACKET_RCVD;
> >  	}
> 
