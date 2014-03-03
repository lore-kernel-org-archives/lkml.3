Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaCCWde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:33:34 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57600 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaCCWdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:33:32 -0500
Date: Mon, 3 Mar 2014 17:33:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
Message-ID: <20140303223327.GB26523@mtj.dyndns.org>
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 10:00:11PM -0500, Sasha Levin wrote:
> rcu read lock should be held when calling and working with task_css_set.
> 
> This patch also fixes a related lockdep warning.

Hmmm... PF_EXITING should be visible at that point and cset can't
change anymore.  We prolly need to update lockdep annotation rather
than adding spurious rcu locking around it.  Against which branch is
it?  Can you please post the lockdep warning?

Thanks.

-- 
tejun
