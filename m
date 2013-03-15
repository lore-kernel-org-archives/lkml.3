Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3COLO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:14:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52417 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab3COLO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:14:57 -0400
Date: Fri, 15 Mar 2013 11:14:54 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: Cut down on the average # of nodes in the
	rbtree cache
Message-ID: <20130315111454.GA30777@opensource.wolfsonmicro.com>
References: <1363272755-6179-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130315013534.GF4931@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315013534.GF4931@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 01:35:34AM +0000, Mark Brown wrote:
> On Thu, Mar 14, 2013 at 02:52:35PM +0000, Dimitris Papastamos wrote:
> 
> >  	if (rbnode) {
> >  		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
> > +		/* Does this register exist?  If not bail out. */
> > +		if (!(rbtree_ctx->reg_present[BIT_WORD(reg)] & BIT_MASK(reg)))
> > +			return -ENOENT;
> >  		*value = regcache_rbtree_get_register(map, rbnode, reg_tmp);
> 
> This means that every caller is going to need to have a check added to
> see if the register is present which doesn't seem great, we should at
> least have a function to do the check.  The check is fiddly enough.

Yea makes sense, will factor it out.

Thanks,
Dimitris
