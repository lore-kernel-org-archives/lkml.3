Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3FNJ1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:27:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:20969 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab3FNJ1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:27:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,864,1363158000"; 
   d="scan'208";a="353229648"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130614090217.GA7574@dhcp22.suse.cz>
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130614090217.GA7574@dhcp22.suse.cz>
Subject: Re: [PATCH 1/8] mm/writeback: fix wb_do_writeback exported unsafely
Content-Transfer-Encoding: 7bit
Message-Id: <20130614092952.AAED5E0090@blue.fi.intel.com>
Date: Fri, 14 Jun 2013 12:29:52 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko wrote:
> On Fri 14-06-13 15:30:34, Wanpeng Li wrote:
> > There is just one caller in fs-writeback.c call wb_do_writeback and
> > current codes unnecessary export it in header file, this patch fix
> > it by changing wb_do_writeback to static function.
> 
> So what?
> 
> Besides that git grep wb_do_writeback tells that 
> mm/backing-dev.c:                       wb_do_writeback(me, 0);
> 
> Have you tested this at all?

Commit 839a8e8 removes that.

> > Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
