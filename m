Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab3CLUIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:08:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55611 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554Ab3CLUIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:08:21 -0400
Date: Tue, 12 Mar 2013 20:08:17 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: Expose total memory consumption in the
	rbtree debugfs entry
Message-ID: <20130312200817.GA32039@opensource.wolfsonmicro.com>
References: <1363109209-23170-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130312181246.GA19942@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312181246.GA19942@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 06:12:47PM +0000, Mark Brown wrote:
> On Tue, Mar 12, 2013 at 05:26:49PM +0000, Dimitris Papastamos wrote:
> 
> > +	mem_size = sizeof(*rbtree_ctx);
> > +
> >  	for (node = rb_first(&rbtree_ctx->root); node != NULL;
> >  	     node = rb_next(node)) {
> >  		n = container_of(node, struct regcache_rbtree_node, node);
> > +		mem_size += sizeof(*n);
> > +		mem_size += (n->blklen * map->cache_word_size);
> 
> This appears to ignore the size of the node structure and only have the
> root context and the data.

I've got mem_size += sizeof(*n) which is the size of the rbnode.  That
contains the underlying rbtree node links.

Thanks,
Dimitris
