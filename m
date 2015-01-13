Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbbAMOPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:15:25 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57269 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbbAMOPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:15:24 -0500
Date: Tue, 13 Jan 2015 09:15:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: remove extra newlines from memcg oom kill log
Message-ID: <20150113141515.GA8180@phnom.home.cmpxchg.org>
References: <1421131539-3211-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421131539-3211-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:45:39PM -0800, Greg Thelen wrote:
> Commit e61734c55c24 ("cgroup: remove cgroup->name") added two extra
> newlines to memcg oom kill log messages.  This makes dmesg hard to read
> and parse.  The issue affects 3.15+.
> Example:
>   Task in /t                          <<< extra #1
>    killed as a result of limit of /t
>                                       <<< extra #2
>   memory: usage 102400kB, limit 102400kB, failcnt 274712
> 
> Remove the extra newlines from memcg oom kill messages, so the messages
> look like:
>   Task in /t killed as a result of limit of /t
>   memory: usage 102400kB, limit 102400kB, failcnt 240649
> 
> Fixes: e61734c55c24 ("cgroup: remove cgroup->name")
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
