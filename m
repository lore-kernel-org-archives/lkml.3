Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3FUAbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:31:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:29829 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab3FUAbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,908,1363158000"; 
   d="scan'208";a="353261210"
Date: Fri, 21 Jun 2013 08:31:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Namjae Jeon <linkinjeon@gmail.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] mm/writeback: Don't check force_wait to handle
 bdi->work_list
Message-ID: <20130621003103.GC11033@localhost>
References: <1371599563-6424-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371599563-6424-2-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130620134615.GA10909@localhost>
 <20130620233724.GA26898@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620233724.GA26898@hacker.(null)>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 07:37:25AM +0800, Wanpeng Li wrote:
> On Thu, Jun 20, 2013 at 09:46:15PM +0800, Fengguang Wu wrote:
> >>  fs/fs-writeback.c |   10 ++--------
> >>  1 files changed, 2 insertions(+), 8 deletions(-)
> >
> >The header file should be changed, too. Otherwise looks fine to me.
> >
> >include/linux/writeback.h:97:long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
> 
> Thanks for your review, Fengguang. ;-)
> 
> The line in header file has already been removed by commit(836f29bbb0:
> fs/fs-writeback.c: : make wb_do_writeback() as static) in -next tree
> since there is just one caller in fs/fs-writeback.c.

Ah OK. I was reading the upstream kernel.. However it still presents a
tricky situation (for Andrew Morton) that commit 836f29bbb0 MUST be
merged before your patch in the next merge window. Otherwise it will
lead to a range of build failure commits.

Thanks,
Fengguang
