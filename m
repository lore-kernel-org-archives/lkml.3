Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3I2Pp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:45:56 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:58414 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3I2Pps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:45:48 -0400
Date: Sun, 29 Sep 2013 17:45:46 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Oussama Ghorbel <oghorbell@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ou.ghorbel@gmail.com
Subject: Re: [PATCH] IPv6: Allow the MTU of ipip6 tunnel to be set below 1280
Message-ID: <20130929154546.GA10771@order.stressinduktion.org>
Mail-Followup-To: Oussama Ghorbel <oghorbell@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ou.ghorbel@gmail.com
References: <1380207108-20030-1-git-send-email-oghorbell@gmail.com> <20130927083730.GC28287@order.stressinduktion.org> <CA+ev270=P9txSvo7AZN0YcsopwhCYtJCgcZCPsdofEJ+BX+EUQ@mail.gmail.com> <20130927105856.GF28287@order.stressinduktion.org> <CA+ev272+Gp6Kt7S8P-wXxPBh0D8Di9WVH9NDi41HpNakLKC4Dw@mail.gmail.com> <20130927170345.GC10343@order.stressinduktion.org> <CA+ev270d2Ztq9i34Lv9U15y1TbH7W-fioXFn-Q_sJd5F4biHuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+ev270d2Ztq9i34Lv9U15y1TbH7W-fioXFn-Q_sJd5F4biHuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 10:40:11AM +0100, Oussama Ghorbel wrote:
> On Fri, Sep 27, 2013 at 6:03 PM, Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
> > Ok, let's go with one function per protocol type. Seems easier.
> >
> > It seems to get more hairy, because it depends on the tunnel driver if the
> > prepended ip header is accounted in hard_header_len. :/
> >
> > I don't know if it works out cleanly. Otherwise I would be ok if the checks
> > just get repeated in ip6_tunnel and leave the rest as-is.
> >
> Yes, It will be the clean way to do it.

Fine. :)

> >
> > Linux currently cannot create "jumbograms" (only the receiving side
> > is supported).
> >
> I understand, but what are the benefit from this limit or the harm
> from not specifying it?
> Please check this comment from eth.c
> 
> /**
>  * eth_change_mtu - set new MTU size
>  * @dev: network device
>  * @new_mtu: new Maximum Transfer Unit
>  *
>  * Allow changing MTU size. Needs to be overridden for devices
>  * supporting jumbo frames.
>  */
> int eth_change_mtu(struct net_device *dev, int new_mtu)

Hmm, I cannot judge without the full patch. Will it be applicable
to all net_devices or just ethernet ones? The name could be a bit
misleading. Remindes me a lot of dev_set_mtu based on the signature, btw.

> So wouldn't be a good idea to let our function open for jumbo frames...?

Hm, we can document the fact that the function would needed to be updated in
that case. But we should not allow to set a mtu which would require jumbograms
currently.

Greetings,

  Hannes

