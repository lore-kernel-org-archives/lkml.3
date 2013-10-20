Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab3JTDdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 23:33:16 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:45857 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3JTDdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 23:33:15 -0400
Date: Sun, 20 Oct 2013 05:33:13 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/9] Introduce support to lazy initialize mostly static keys
Message-ID: <20131020033313.GB27787@order.stressinduktion.org>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382212139-20301-1-git-send-email-hannes@stressinduktion.org> <20131019.194635.2189923305870380269.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131019.194635.2189923305870380269.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 07:46:35PM -0400, David Miller wrote:
> From: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Date: Sat, 19 Oct 2013 21:48:50 +0200
> 
> > This series implements support for delaying the initialization of secret
> > keys, e.g. used for hashing, for as long as possible. This functionality
> > is implemented by a new macro, net_get_random_bytes.
> > 
> > I already used it to protect the socket hashes, the syncookie secret
> > (most important) and the tcp_fastopen secrets.
> > 
> > Changelog:
> > v2) Use static_keys in net_get_random_once to have as minimal impact to
> >     the fast-path as possible.
> > v3) added patch "static_key: WARN on usage before jump_label_init was called":
> >     Patch "x86/jump_label: expect default_nop if static_key gets enabled
> >     on boot-up" relaxes the checks for using static_key primitives before
> >     jump_label_init. So tighten them first.
> > v4) Update changelog on the patch "static_key: WARN on usage before
> >     jump_label_init was called"
> 
> Although I was very skeptical about these changes when you first posted
> them, I am quite happy with this series now.

Thank you, too! I was afraid that without the necessary acks from x86
and jump-label maintainers it would have been impossible to merge.

> 
> Thanks for working on this and not giving up :-)
> 
> Series applied, thanks a lot!

I received build warnings from kbuild just after merging and will fix
them up. Mostly ia64 and allnoconfig. Will send patches soon.

Thanks,

  Hannes

