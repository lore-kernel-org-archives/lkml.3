Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaETAgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:36:33 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39166 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbaETAgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:36:32 -0400
X-IronPort-AV: E=Sophos;i="4.98,870,1392159600"; 
   d="scan'208";a="74716770"
Date: Tue, 20 May 2014 08:36:24 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
        kernel-janitors@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/13] libertas: make return of 0 explicit
In-Reply-To: <5379FCD0.2030506@cogentembedded.com>
Message-ID: <alpine.DEB.2.10.1405200835490.2723@hadrien>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr> <5379FCD0.2030506@cogentembedded.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2014, Sergei Shtylyov wrote:

> Hello.
>
> On 19-05-2014 8:31, Julia Lawall wrote:
>
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> > Delete unnecessary local variable whose value is always 0 and that hides
> > the fact that the result is always 0.
>
> > A simplified version of the semantic patch that fixes this problem is as
> > follows: (http://coccinelle.lip6.fr/)
>
> > // <smpl>
> > @r exists@
> > local idexpression ret;
> > expression e;
> > position p;
> > @@
> >
> > -ret = 0;
> > ... when != ret = e
> > return
> > - ret
> > + 0
> >    ;
> > // </smpl>
>
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> > ---
> > Alternatively, was an error code intended in the bad length case, as is
> > done in process_brxed_802_11_packet?
>
> >   drivers/net/wireless/libertas/rx.c |    7 ++-----
> >   1 file changed, 2 insertions(+), 5 deletions(-)
>
> > diff --git a/drivers/net/wireless/libertas/rx.c
> > b/drivers/net/wireless/libertas/rx.c
> > index c7366b0..807c5b8 100644
> > --- a/drivers/net/wireless/libertas/rx.c
> > +++ b/drivers/net/wireless/libertas/rx.c
> [...]
> > @@ -154,10 +152,9 @@ int lbs_process_rxed_packet(struct lbs_private *priv,
> > struct sk_buff *skb)
> >   	else
> >   		netif_rx_ni(skb);
> >
> > -	ret = 0;
> >   done:
> > -	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
> > -	return ret;
> > +	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", 0);
>
>    Why not just "ret 0"?

Oops, I won't make any change here, because Dan Williams has proposed
another patch that makes the ret variable useful.

julia
