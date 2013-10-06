Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3JFPNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:13:54 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:43862 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3JFPNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:13:53 -0400
Date: Sun, 6 Oct 2013 17:13:51 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Oussama Ghorbel <ou.ghorbel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the upper MTU limit in ipv6 GRE tunnel
Message-ID: <20131006151351.GB9295@order.stressinduktion.org>
Mail-Followup-To: Oussama Ghorbel <ou.ghorbel@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1380880333-3546-1-git-send-email-ou.ghorbel@gmail.com> <20131005140636.GA25076@order.stressinduktion.org> <CABfLueFYZkzpEpDJ7YcHJaXfm-=QcgnL3-Es8gybea2cAacQQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABfLueFYZkzpEpDJ7YcHJaXfm-=QcgnL3-Es8gybea2cAacQQw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 03:42:15PM +0100, Oussama Ghorbel wrote:
> The initialization  in ip6gre_tnl_link_config is done as the following:
> static void ip6gre_tnl_link_config(struct ip6_tnl *t, int set_mtu)
> {
> ...
> int addend = sizeof(struct ipv6hdr) + 4;
> ...
> /* Precalculate GRE options length */
> if (t->parms.o_flags&(GRE_CSUM|GRE_KEY|GRE_SEQ)) {
> if (t->parms.o_flags&GRE_CSUM)
> addend += 4;
> if (t->parms.o_flags&GRE_KEY)
> addend += 4;
> if (t->parms.o_flags&GRE_SEQ)
> addend += 4;
> }
> ...
> dev->hard_header_len = rt->dst.dev->hard_header_len + addend;
> ...
> t->hlen = addend;
> ..
> }
> 
> Unless they are other reasons, the hard_header_len is taken into
> account the GRE_KEY, GRE_SEQ ..

But only if a new route is found. The hard_header_len reinitialization is
guarded by a (rt == NULL). We may have not found one on boot up.

> > To make this correct we would have to refactor the usage of the variables a
> > bit as is done in ipv4/ip_tunnel.c. The safest thing would be to leave this
> > check as-is currently although we exclude some allowed mtus.
> >
> > Perhaps you want to take a look how to achieve that? ;)
> >
> Why not, consistency is good ...

Thanks,

  Hannes

