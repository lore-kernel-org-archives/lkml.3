Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935455AbaDJSf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:35:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934885AbaDJSf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:35:27 -0400
Date: Thu, 10 Apr 2014 20:35:26 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/22] ext2: Remove ext2_xip_verify_sb()
Message-ID: <20140410183526.GB8060@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <5f91cb658e1ee1b593be9fd719e8f204b0069031.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409095254.GE32103@quack.suse.cz>
 <20140410142254.GI5727@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410142254.GI5727@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-04-14 10:22:54, Matthew Wilcox wrote:
> On Wed, Apr 09, 2014 at 11:52:54AM +0200, Jan Kara wrote:
> > > -	if ((sbi->s_mount_opt ^ old_mount_opt) & EXT2_MOUNT_XIP) {
> > > +	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT2_MOUNT_XIP) {
> > >  		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
> > >  			 "xip flag with busy inodes while remounting");
> > > -		sbi->s_mount_opt &= ~EXT2_MOUNT_XIP;
> > > -		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
> > > +		sbi->s_mount_opt ^= EXT2_MOUNT_XIP;
> >   Although this is correct, it was easier to see that the previous code is
> > correct so I'd prefer if you kept it that way.
> 
> Depends how you think about it.  I think of foo ^= bar as 'toggle the
> bar bit in foo'.  So I read the code as 'If the mount bit is incorrect,
> print an error and toggle the bit'.  I think you're reading the old code
> as 'If the new mount bit differs from the old mount bit, make sure the
> new mount bit is the same as the old mount bit'.
  Yeah, since it's pretty obvious what the code should do, one can figure
out it is correct relatively quickly. But it's something that wasn't
obvious to me at the first sight. If you really prefer your way, I can live
with that...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
