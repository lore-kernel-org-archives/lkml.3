Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935562AbaDJOYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:24:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:45650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934688AbaDJOYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:24:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="518525435"
Date: Thu, 10 Apr 2014 10:22:54 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/22] ext2: Remove ext2_xip_verify_sb()
Message-ID: <20140410142254.GI5727@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <5f91cb658e1ee1b593be9fd719e8f204b0069031.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409095254.GE32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409095254.GE32103@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:52:54AM +0200, Jan Kara wrote:
> > -	if ((sbi->s_mount_opt ^ old_mount_opt) & EXT2_MOUNT_XIP) {
> > +	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT2_MOUNT_XIP) {
> >  		ext2_msg(sb, KERN_WARNING, "warning: refusing change of "
> >  			 "xip flag with busy inodes while remounting");
> > -		sbi->s_mount_opt &= ~EXT2_MOUNT_XIP;
> > -		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
> > +		sbi->s_mount_opt ^= EXT2_MOUNT_XIP;
>   Although this is correct, it was easier to see that the previous code is
> correct so I'd prefer if you kept it that way.

Depends how you think about it.  I think of foo ^= bar as 'toggle the
bar bit in foo'.  So I read the code as 'If the mount bit is incorrect,
print an error and toggle the bit'.  I think you're reading the old code
as 'If the new mount bit differs from the old mount bit, make sure the
new mount bit is the same as the old mount bit'.
