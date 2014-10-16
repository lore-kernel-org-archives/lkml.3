Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaJPUnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:43:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaJPUnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:43:09 -0400
Date: Thu, 16 Oct 2014 22:39:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
	tree
Message-ID: <20141016203954.GA26336@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix the issue by checking for TIF_MEMDIE thread flag and get away from the
> fridge if it is set.  oom_scan_process_thread doesn't have to check for
> the frozen task anymore because do_send_sig_info will wake up the thread
> and TIF_MEMDIE is already set by that time.

I must have missed something... but __refrigerator() sleeps in
TASK_UNINTERRUPTIBLE and do_send_sig_info() won't wake it up?

Oleg.

