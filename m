Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3IQXdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:33:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:16800 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab3IQXdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:33:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,926,1371106800"; 
   d="scan'208";a="397267234"
Date: Wed, 18 Sep 2013 07:33:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] regulator: fix fatal kernel-doc error
Message-ID: <20130917233328.GC11390@localhost>
References: <5237AB72.5020806@infradead.org>
 <20130917103238.GM21013@sirena.org.uk>
 <52388CC4.7040101@infradead.org>
 <20130917192355.GK21013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917192355.GK21013@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 08:23:55PM +0100, Mark Brown wrote:
> On Tue, Sep 17, 2013 at 10:09:24AM -0700, Randy Dunlap wrote:
> > On 09/17/13 03:32, Mark Brown wrote:
 
> > /** means kernel-doc syntax and it was not in proper kernel-doc format,
> > but maybe it could just be a Warning instead of a fatal Error.
> 
> Yes, that's what I'm saying - it really doesn't seem like something that
> should be a fatal error, that's far too fragile.
> 
> > Ideally we should pick it up in -next, of course, but I doubt that anyone
> > is running kernel-doc on linux-next.  I used to do that, but there are
> > too many errors/warnings.  I suppose that I could just concentrate on
> > (fatal) Errors in linux-next and ignore the Warnings.
> 
> Could these checks be added to Fengguang's tester?  If nobody's looking
> at the output (I've never found the processed output useful myself) or
> running the tool then it's a bit worrying...

Yes, I'm running "make htmldocs" checks and send out all new warnings:

 Sep 03 To Mark Brown   (  19:0) [regulator:topic/devm 5/15] Warning(drivers/regulator/core.c:3750): No description found for parameter 'dev'
 Sep 06 To Miklos Szere (  20:0) [vfs:for-miklos 34/43] Warning(fs/dcache.c:1167): No description found for parameter 'data'
 Sep 10 To Waiman Long  (  22:0) [vfs:for-next 9/10] Warning(fs/dcache.c:102): No description found for parameter 'lock'
 Sep 11 To Lars-Peter C (  25:0) [xlnx:master-next 96/99] Warning(drivers/gpu/drm/drm_edid.c:1061): No description found for parameter 'data'    
 Sep 12 To Brian Norris (  13:0) [l2-mtd:master 9/11] Warning(include/linux/mtd/nand.h:587): Excess struct/union/enum/typedef member 'ecclayout'

Does that sound enough?

Thanks,
Fengguang
