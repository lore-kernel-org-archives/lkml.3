Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaKZLdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:33:52 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40871 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbaKZLdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:33:50 -0500
Date: Wed, 26 Nov 2014 12:33:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Andreas Ruprecht <rupran@einserver.de>, Florian Westphal <fw@strlen.de>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: netfilter: Fix undefined reference to
 nf_nat_redirect_* functions
Message-ID: <20141126113348.GC24801@breakpoint.cc>
References: <1416928034-10882-1-git-send-email-rupran@einserver.de>
 <1416994537-1592-1-git-send-email-rupran@einserver.de>
 <20141126102402.GA24801@breakpoint.cc>
 <5475AC6F.9010902@einserver.de>
 <20141126112449.GA4700@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126112449.GA4700@salvia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 2) Merge nf_nat_redirect_ipv4 and nf_nat_redirect_ipv6 into
> nf_nat_redirect, so we inconditionally build IPv6 redirect code, thus
> xt_REDIRECT always finds the IPv6 symbol that needs even if it doesn't
> use it.

Seems this is the best solution since it would also reduce the
kconfig option symbol count.

afaics there is nothing ipv6 specific in nf_nat_redirect_ipv6 so
this should not cause any of the ususal IPV6=m dependency issues.
