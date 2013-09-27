Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3I0Qgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:36:51 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:41160 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3I0Qgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:36:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130927105856.GF28287@order.stressinduktion.org>
References: <1380207108-20030-1-git-send-email-oghorbell@gmail.com>
	<20130927083730.GC28287@order.stressinduktion.org>
	<CA+ev270=P9txSvo7AZN0YcsopwhCYtJCgcZCPsdofEJ+BX+EUQ@mail.gmail.com>
	<20130927105856.GF28287@order.stressinduktion.org>
Date: Fri, 27 Sep 2013 17:36:45 +0100
Message-ID: <CA+ev272+Gp6Kt7S8P-wXxPBh0D8Di9WVH9NDi41HpNakLKC4Dw@mail.gmail.com>
Subject: Re: [PATCH] IPv6: Allow the MTU of ipip6 tunnel to be set below 1280
From: Oussama Ghorbel <oghorbell@gmail.com>
To: Oussama Ghorbel <oghorbell@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see my comments below

Regards,
Oussama

On Fri, Sep 27, 2013 at 11:58 AM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> On Fri, Sep 27, 2013 at 11:45:48AM +0100, Oussama Ghorbel wrote:
>> The ip6_tunnel.c module would be then dependent on ip_tunnel.c and may
>> be it would not be good thing?
>
> It could just be a static inline in some shared header. So there would
> be no compile-time dependency.
>

The higher limit of mtu in ip_tunnel_change_mtu() is a calculated value.
This high limit is calculated using the netdev priv struct ip_tunnel
(field hlen).
This netdev priv struct is different in ipv6, it's a ip6_tnl struct.
Therefore implementing a beautiful function like
ip_tunnel_valid_mtu(struct net_device *dev, int mtu) won't be
feasible, unless we implement it in macro or something like like
ip_tunnel_valid_mtu(struct net_device *dev, int hlen, int mtu) which
seems not very nice ...
What do yo think?

>> As I have check in v3.10 there is no call from ip6_tunnel to ip_tunnel...
>>
>> For information, there is no check for the maximum MTU for ipv4 in the
>> patch as this is not done for ipv6.
>
> I understand, but it would be better to limit the MTU here. There is a
> (non-jumo) IPV6_MAXPLEN constant.
>
> Looking through the source it seems grev6 does actually check this,
> so it would not hurt adding them here, too.

what if jumbograms is used, in that case, we can't use IPV6_MAXPLEN.
the limit would be the the full unsigned int.
However checking the higher limit for ipv4 would be useful.

Please also note in case the tunnel mode is any (ipv4 or ipv6 means
ip6_tnl.parms.proto = 0), then we will be required to take the most
restrict limit from both ipv4 and ipv6 which means the lower limit
will be 1280 and the higher limit will be about 65535
Do you agree on this?

>
> Otherwise, I think your patch is fine.
>
> Greetings,
>
>   Hannes
>
