Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3I0K7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:59:01 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:54870 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3I0K66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:58:58 -0400
Date: Fri, 27 Sep 2013 12:58:56 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Oussama Ghorbel <oghorbell@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv6: Allow the MTU of ipip6 tunnel to be set below 1280
Message-ID: <20130927105856.GF28287@order.stressinduktion.org>
Mail-Followup-To: Oussama Ghorbel <oghorbell@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1380207108-20030-1-git-send-email-oghorbell@gmail.com> <20130927083730.GC28287@order.stressinduktion.org> <CA+ev270=P9txSvo7AZN0YcsopwhCYtJCgcZCPsdofEJ+BX+EUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+ev270=P9txSvo7AZN0YcsopwhCYtJCgcZCPsdofEJ+BX+EUQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 11:45:48AM +0100, Oussama Ghorbel wrote:
> The ip6_tunnel.c module would be then dependent on ip_tunnel.c and may
> be it would not be good thing?

It could just be a static inline in some shared header. So there would
be no compile-time dependency.

> As I have check in v3.10 there is no call from ip6_tunnel to ip_tunnel...
> 
> For information, there is no check for the maximum MTU for ipv4 in the
> patch as this is not done for ipv6.

I understand, but it would be better to limit the MTU here. There is a
(non-jumo) IPV6_MAXPLEN constant.

Looking through the source it seems grev6 does actually check this,
so it would not hurt adding them here, too.

Otherwise, I think your patch is fine.

Greetings,

  Hannes

