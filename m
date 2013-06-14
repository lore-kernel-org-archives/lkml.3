Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3FNJcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:32:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3FNJcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:32:01 -0400
Date: Fri, 14 Jun 2013 11:31:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/writeback: fix wb_do_writeback exported unsafely
Message-ID: <20130614093159.GB10084@dhcp22.suse.cz>
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130614090217.GA7574@dhcp22.suse.cz>
 <20130614092952.AAED5E0090@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614092952.AAED5E0090@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-06-13 12:29:52, Kirill A. Shutemov wrote:
> Michal Hocko wrote:
> > On Fri 14-06-13 15:30:34, Wanpeng Li wrote:
> > > There is just one caller in fs-writeback.c call wb_do_writeback and
> > > current codes unnecessary export it in header file, this patch fix
> > > it by changing wb_do_writeback to static function.
> > 
> > So what?
> > 
> > Besides that git grep wb_do_writeback tells that 
> > mm/backing-dev.c:                       wb_do_writeback(me, 0);
> > 
> > Have you tested this at all?
> 
> Commit 839a8e8 removes that.

OK, I didn't check the most up-to-date tree. Sorry about this confusion.
I do not object to cleanups like this but it should be clear they are
cleanups. "fix wb_do_writeback exported unsafely" sounds like a fix
rather than a cleanup

> > > Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> 
> -- 
>  Kirill A. Shutemov
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
