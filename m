Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab3D2V5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:57:52 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39992 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab3D2V5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:57:50 -0400
Date: Mon, 29 Apr 2013 14:57:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Li Zefan <lizefan@huawei.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP
 set
Message-ID: <20130429215745.GB2395@htj.dyndns.org>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-3-git-send-email-ccross@android.com>
 <20130429215157.GA2395@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429215157.GA2395@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 02:51:57PM -0700, Tejun Heo wrote:
> I feel a bit weary of changes which try to optimize state checks for
> freezer because the synchronization rules are kinda fragile and things
> may not work reliably depending on who's testing the flag, and it has
> been subtly broken in various ways in the past (maybe even now).  Can

And BTW, this is why the function is only used when checking whether a
task is frozen rather than to decide to issue freeze_task() on it, and
it seems your change is correct now that we don't have per-task FREEZE
flag but I can't say I like the change.  I'd really like to keep
things as dumb as possible for freezer.

Thanks.

-- 
tejun
