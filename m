Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab3FRTAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:00:36 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:36174 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3FRTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:00:34 -0400
Date: Tue, 18 Jun 2013 12:00:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] mm/writeback: Don't check force_wait to handle
 bdi->work_list
Message-ID: <20130618190027.GF1596@htj.dyndns.org>
References: <1371555222-22678-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371555222-22678-2-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371555222-22678-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 07:33:38PM +0800, Wanpeng Li wrote:
> After commit 839a8e86("writeback: replace custom worker pool implementation
> with unbound workqueue"), bdi_writeback_workfn runs off bdi_writeback->dwork,
> on each execution, it processes bdi->work_list and reschedules if there are
> more things to do instead of flush any work that race with us existing. It is
> unecessary to check force_wait in wb_do_writeback since it is always 0 after
> the mentioned commit. This patch remove the force_wait in wb_do_writeback.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
