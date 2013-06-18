Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab3FRTBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:01:46 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:41841 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab3FRTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:01:44 -0400
Date: Tue, 18 Jun 2013 12:01:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/6] mm/writeback: commit reason of
 WB_REASON_FORKER_THREAD mismatch name
Message-ID: <20130618190139.GG1596@htj.dyndns.org>
References: <1371555222-22678-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371555222-22678-3-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371555222-22678-3-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 07:33:39PM +0800, Wanpeng Li wrote:
> After commit 839a8e86("writeback: replace custom worker pool implementation
> with unbound workqueue"), there is no bdi forker thread any more. However,
> WB_REASON_FORKER_THREAD is still used due to it is somewhat userland visible
> and we won't be exposing exactly the same information with just a different
> name.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

> +/*
> + * There is no bdi forker thread any more and works are done by emergency
> + * worker, however, this is somewhat userland visible and we'll be exposing
> + * exactly the same information, so it has a mismatch name.
> + */
>  	WB_REASON_FORKER_THREAD,

But it'd be probably better to explicitly point to the TPs rather than
saying "somewhat" visible.

Thanks.

-- 
tejun
