Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab3JNVYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:24:14 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:40621 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757313Ab3JNVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:24:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3657:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:7576:7652:7875:8599:9010:9025:9388:10004:10400:10848:11026:11232:11253:11658:11854:11914:12043:12114:12214:12438:12517:12519:12740:12776:13069:13095:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bu
X-HE-Tag: tail03_7ba860f72e250
X-Filterd-Recvd-Size: 2732
Message-ID: <1381785848.12919.6.camel@joe-AO722>
Subject: Re: [PATCH -next] netdev: inet_timewait_sock.h missing semi-colon
 when KMEMCHECK is enabled
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Date: Mon, 14 Oct 2013 14:24:08 -0700
In-Reply-To: <525C5863.1000505@infradead.org>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
	 <525C47C0.2000907@infradead.org> <1381780437.12919.3.camel@joe-AO722>
	 <525C5863.1000505@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 13:47 -0700, Randy Dunlap wrote:
> On 10/14/13 12:53, Joe Perches wrote:
> > On Mon, 2013-10-14 at 12:36 -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >>
> >> Fix (a few hundred) build errors due to missing semi-colon when
> >> KMEMCHECK is enabled:
> >>
> >>   include/net/inet_timewait_sock.h:139:2: error: expected ',', ';' or '}' before 'int'
> >>   include/net/inet_timewait_sock.h:148:28: error: 'const struct inet_timewait_sock' has no member named 'tw_death_node'
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >> ---
> >>  include/net/inet_timewait_sock.h |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> --- next-2013-1014.orig/include/net/inet_timewait_sock.h
> >> +++ next-2013-1014/include/net/inet_timewait_sock.h
> >> @@ -135,7 +135,7 @@ struct inet_timewait_sock {
> >>  				tw_transparent  : 1,
> >>  				tw_pad		: 6,	/* 6 bits hole */
> >>  				tw_tos		: 8,
> >> -				tw_pad2		: 16 /* 16 bits hole */
> >> +				tw_pad2		: 16;	/* 16 bits hole */
> >>  	kmemcheck_bitfield_end(flags);
> >>  	u32			tw_ttd;
> >>  	struct inet_bind_bucket	*tw_tb;
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > Shouldn't this be done in kmemcheck.h?
> 
> This patch makes sense and probably should be merged
> but it does not fix the build errors that I reported.

You sure?


