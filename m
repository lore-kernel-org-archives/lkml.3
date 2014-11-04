Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaKDJIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:08:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaKDJIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:08:19 -0500
Date: Tue, 4 Nov 2014 10:08:14 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Beulich <JBeulich@suse.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: your patch "mm: Remove false WARN_ON from
 pagecache_isize_extended()"
Message-ID: <20141104090814.GA2953@quack.suse.cz>
References: <5457BE390200007800044838@mail.emea.novell.com>
 <20141103221849.GB23575@dastard>
 <545890F40200007800044A31@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545890F40200007800044A31@mail.emea.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 07:40:20, Jan Beulich wrote:
> >>> On 03.11.14 at 23:18, <david@fromorbit.com> wrote:
> > On Mon, Nov 03, 2014 at 04:41:13PM +0000, Jan Beulich wrote:
> >> having run into that warning too, I looked into it a little, and now
> >> having found that patch am pretty uncertain: Both truncate_setsize()
> >> and pagecache_isize_extended() document that they want to be
> >> called with i_mutex held, so removing the WARN_ON() alone seems
> >> either incomplete or wrong. What I found to work without violating
> >> this documented requirement is the patch below.
> > 
> > Or, just perhaps, the comments are wrong....
> 
> Right - that's what I was suggesting with the option of the patch
> being incomplete (rather than just removing the WARN_ON() it
> should also remove the respective comments then).
  Yeah, I'll update the comments to mention there are filesystem which use
serialization different from i_mutex. Thanks for catching this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
