Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaAIU4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:56:37 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37014 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189AbaAIU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:56:28 -0500
Date: Thu, 9 Jan 2014 21:56:22 +0100
From: Florian Westphal <fw@strlen.de>
To: Andrew Vagin <avagin@parallels.com>
Cc: Florian Westphal <fw@strlen.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrey Vagin <avagin@openvz.org>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, vvs@openvz.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: fix RCU race in
 nf_conntrack_find_get
Message-ID: <20140109205622.GA29458@breakpoint.cc>
References: <1389090711-15843-1-git-send-email-avagin@openvz.org>
 <1389107305.26646.20.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140107152520.GF9894@breakpoint.cc>
 <20140109203206.GA26348@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109203206.GA26348@paralelels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Vagin <avagin@parallels.com> wrote:
> Can we allocate conntrack with zero ct_general.use and increment it at
> the first time before inserting the conntrack into the hash table?
> When conntrack is allocated it is attached exclusively to one skb.
> It must be destroyed with skb, if it has not been confirmed, so we
> don't need refcnt on this stage.
> 
> I found only one place, where a reference counter of unconfirmed
> conntract can incremented. It's ctnetlink_dump_table().

What about skb_clone, etc?  They will also increment the refcnt
if a conntrack entry is attached to the skb.
