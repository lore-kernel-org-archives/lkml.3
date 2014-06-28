Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaF1UOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:14:09 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17234 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbaF1UOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:14:07 -0400
X-IronPort-AV: E=Sophos;i="5.01,567,1400018400"; 
   d="scan'208";a="82706182"
Date: Sat, 28 Jun 2014 22:14:03 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Antonio Quartulli <antonio@meshcoding.com>
cc: Joe Perches <joe@perches.com>, Himangi Saraogi <himangi774@gmail.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] batman-adv: Use kasprintf
In-Reply-To: <53AF1C42.6000108@meshcoding.com>
Message-ID: <alpine.DEB.2.02.1406282212540.2022@localhost6.localdomain6>
References: <20140628183628.GA9946@himangi-Dell> <1403982781.9064.33.camel@joe-AO725> <53AF1C42.6000108@meshcoding.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014, Antonio Quartulli wrote:

> Hi all,
> 
> On 28/06/14 21:13, Joe Perches wrote:
> > diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
> > index f40cb04..d6fba94 100644
> > --- a/net/batman-adv/sysfs.c
> > +++ b/net/batman-adv/sysfs.c
> > @@ -896,7 +896,7 @@ int batadv_throw_uevent(struct batadv_priv *bat_priv, enum batadv_uev_type type,
> >  {
> >  	int ret = -ENOMEM;
> >  	struct kobject *bat_kobj;
> > -	char *uevent_env[4] = { NULL, NULL, NULL, NULL };
> > +	char *uevent_env[3];
> 
> 
> Joe, why are you shortening this? kobject_uevent_env() expect a
> NULL-terminating array (that is the forth cell).
> 
> ...
> 
> >  
> >  	ret = kobject_uevent_env(bat_kobj, KOBJ_CHANGE, uevent_env);
> 
> And how is this change reducing the code space?
> 
> For what concerns the labels, we use this pattern mostly all over the
> code: one single label/exit-point with the related NULL checks. Do you
> think that we can improve something by changing this? (I am not talking
> about the fastpath here).

Most of the kernel uses specific labels for each possible failure.
>From my selfish point of view, it makes the code easier to analyze and 
understand, because what is done at the exit label is only what needs to 
be done.

julia
