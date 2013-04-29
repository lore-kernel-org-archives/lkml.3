Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab3D2WQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:16:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45614 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3D2WQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:16:29 -0400
Date: Mon, 29 Apr 2013 15:16:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Li Zefan <lizefan@huawei.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP
 set
Message-ID: <20130429221624.GD2395@htj.dyndns.org>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-3-git-send-email-ccross@android.com>
 <20130429215157.GA2395@htj.dyndns.org>
 <20130429215745.GB2395@htj.dyndns.org>
 <CAMbhsRQHkm=XTYtummEZq1h4sa-tRGwLpk8Uyhpj9D3+jQF3dg@mail.gmail.com>
 <20130429220831.GC2395@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429220831.GC2395@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 03:08:31PM -0700, Tejun Heo wrote:
> > spent freezing by a factor of 5.  It will have a similar effect on a
> > non-Android system, although those generally don't care about
> > suspend/resume optimization.
> 
> Yeah, if it's something which makes actual difference rather than
> "this seems to be a good idea" thing, sure, let's find a way.

And a probably better approach would be rolling should_skip test into
freeze_task() with a comment explaining the interlocking rather than
adding should_skip test in its callers.

Thanks.

-- 
tejun
