Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaFRSbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:31:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbaFRSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:31:48 -0400
Date: Wed, 18 Jun 2014 20:31:45 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Joe Perches <joe@perches.com>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFT v5h printk: allow increasing the ring buffer depending on
	the number of CPUs
Message-ID: <20140618183145.GM4841@wotan.suse.de>
References: <1402965464-11202-1-git-send-email-mcgrof@do-not-panic.com> <20140617145200.GA634@pathway.suse.cz> <20140618001816.GK4841@wotan.suse.de> <20140618083102.GF634@pathway.suse.cz> <20140618105926.GL4841@wotan.suse.de> <20140618142144.GH634@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140618142144.GH634@pathway.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 04:21:45PM +0200, Petr Mládek wrote:
> On Wed 2014-06-18 12:59:26, Luis R. Rodriguez wrote:
> > On Wed, Jun 18, 2014 at 10:31:02AM +0200, Petr Mládek wrote:
> > > On Wed 2014-06-18 02:18:16, Luis R. Rodriguez wrote:
> > > I am happy with this solution. And I agree that it is better to split
> > > log_buf_len_align() in a separate patch as you suggested in the other
> > > mail.
> > 
> > OK just to be on safe side I noticed memblock_virt_alloc() and
> > memblock_virt_alloc_nopanic() allow passing an explicit alignment
> > requirement, traced back the orignal code with no good reason to
> > not use the LOG_ALIGN, so I think using that would be the safest
> > thing to do. Will roll that into the first patch, curious if the
> > folks that ran into the alignment issues on ARM could reproduce
> > an align barf without this on some situations, perhaps not because
> > of the power of 2 thing and since the min value for LOG_BUF_SHIFT
> > is 12.
> 
> Great catch. It makes sense to me. There is no reason to have aligned
> stores when the buffer itself is not properly aligned.
> 
> IMHO, it would make sense to have separate patch for this change. It might be
> candidate for stable releases.

OK thanks for the review and all your help, I'll split that up into another
patch, so it'll be 3 total.

  Luis
