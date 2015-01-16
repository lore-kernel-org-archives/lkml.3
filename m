Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbbAPQAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:00:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:45232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbbAPQAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:00:47 -0500
Date: Fri, 16 Jan 2015 16:00:45 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Patrick McHardy <kaber@trash.net>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, paulmck@linux.vnet.ibm.com,
        edumazet@google.com, john.r.fastabend@intel.com, josh@joshtriplett.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/9] rhashtable: Do hashing inside of
 rhashtable_lookup_compare()
Message-ID: <20150116160045.GB15052@casper.infradead.org>
References: <cover.1420230585.git.tgraf@suug.ch>
 <d579f486c3d4a88744dffc23a794601b025b41f4.1420230585.git.tgraf@suug.ch>
 <20150116153740.GG30132@acer.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116153740.GG30132@acer.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/15 at 03:37pm, Patrick McHardy wrote:
> On 02.01, Thomas Graf wrote:
> > +{
> > +	struct nft_hash_elem *he = ptr;
> > +	struct nft_compare_arg *x = arg;
> > +
> > +	if (!nft_data_cmp(&he->key, &x->elem->key, x->set->klen)) {
> > +		x->elem->cookie = &he->node;
> > +		x->elem->flags = 0;
> > +		if (x->set->flags & NFT_SET_MAP)
> > +			nft_data_copy(&x->elem->data, he->data);
> 
> Is there any reason why we need to perform the assignments in the
> compare function? The reason why I'm asking is because to add
> timeout support, I need another compare function for nft_hash_lookup()
> and I'd prefer to use a single one for both cases.

No. I kept the nft_hash code as intact as possible without changing
any semantics (aside from the lost optimiztion of keeping the pprev
pointer from the lookup when doing removals). No reason speaks against
moving it out.
