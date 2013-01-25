Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3AYRT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:19:29 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:53150 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab3AYRTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:19:24 -0500
Date: Fri, 25 Jan 2013 09:19:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: Re: Crash with 9fdb04c "async: replace list of active domains with
 global list of pending items"
Message-ID: <20130125171920.GF3081@htj.dyndns.org>
References: <510216ED.1090602@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510216ED.1090602@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 24, 2013 at 09:23:57PM -0800, Stephen Warren wrote:
> In next-20130124, I see a crash during boot on my ARM system unless I
> revert 9fdb04c "async: replace list of active domains with global list
> of pending items". This was reported t me by Venu (CC'd). The kernel log
> is below.
> 
> Looking at that patch, I note that __async_schedule() does:
> 
> > 	list_add_tail(&entry->domain_list, &domain->pending);
> > 	if (domain->registered)
> > 		list_add_tail(&entry->global_list, &async_global_pending);
> 
> ... whereas async_run_entry_fn() unconditionally undoes both those
> list_add_tail() calls, even if the second never executed and hence the
> list entry was never initialized:
> 
> > 	list_del_init(&entry->domain_list);
> > 	list_del_init(&entry->global_list);

Was reported by James Hogan a bit earlier and fix has been applied.

  http://thread.gmane.org/gmane.linux.kernel/1425387/focus=1429460

Thanks!

-- 
tejun
