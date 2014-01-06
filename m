Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbaAFVoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:44:44 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38285 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbaAFVol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:44:41 -0500
Date: Tue, 7 Jan 2014 01:44:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Andrey Vagin <avagin@openvz.org>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, vvs@openvz.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: nf_conntrack: release conntrack from rcu
 callback
Message-ID: <20140106214438.GC2360@moon>
References: <1389023672-14351-1-git-send-email-avagin@openvz.org>
 <20140106170235.GJ28854@breakpoint.cc>
 <20140106172130.GA2360@moon>
 <20140106212326.GB9894@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106212326.GB9894@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 10:23:26PM +0100, Florian Westphal wrote:
> > 
> > No? Or there something obvious I'm missing?
> 
> IMHO this isn't obvious at all :-)
> 
> But, in the example above, the atomic_inc_not_zero() should fail
> until after __nf_conntrack_alloc() re-inits the refcount to 1.
> 
> The mb there should make sure ____nf_conntrack_find() doesn't
> find an outdated tuple before this.

Yeah, thanks!
