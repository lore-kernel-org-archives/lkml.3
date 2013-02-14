Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab3BNPAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:00:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55608 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757239Ab3BNPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:00:52 -0500
Date: Thu, 14 Feb 2013 15:00:50 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regmap: debugfs: Add a registers `range' file
Message-ID: <20130214150050.GA24369@opensource.wolfsonmicro.com>
References: <1360845104-30392-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130214144305.GP13249@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214144305.GP13249@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:43:06PM +0000, Mark Brown wrote:
> On Thu, Feb 14, 2013 at 12:31:44PM +0000, Dimitris Papastamos wrote:
> 
> > @@ -96,6 +116,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
> >  				if (c) {
> >  					c->max = p - 1;
> >  					c->max_reg = i - 1;
> > +					c->reg_attr = regmap_attr_bitmap(map, c->max_reg);
> >  					list_add_tail(&c->list,
> >  						      &map->debugfs_off_cache);
> >  					c = NULL;
> 
> What happens if we have three registers like below?
> 
>    X:   read, write
>    X+1: read, write, volatile
>    X+2: read, write
> 
> It looks like we'll not flag X+1 as volatile, we'll just take the last
> value we saw.

Hm yes, right.  So the problem here is that we split on the condition that
is something is printable or not.  We do not actually split on any of the
possible changes of the register attributes.  Any of the blocks of registers
should have registers that have exactly the same set of attributes.

I will look into this to fix.

Thanks,
Dimitris
