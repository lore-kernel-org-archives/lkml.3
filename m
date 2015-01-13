Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbbAMXUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:20:36 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:53292 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbbAMXUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:20:33 -0500
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org> <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for memory
In-reply-to: <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
Date: Tue, 13 Jan 2015 15:20:08 -0800
Message-ID: <xr93a91mz2s7.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jan 08 2015, Johannes Weiner wrote:

> Introduce the basic control files to account, partition, and limit
> memory using cgroups in default hierarchy mode.
>
> This interface versioning allows us to address fundamental design
> issues in the existing memory cgroup interface, further explained
> below.  The old interface will be maintained indefinitely, but a
> clearer model and improved workload performance should encourage
> existing users to switch over to the new one eventually.
>
> The control files are thus:
>
>   - memory.current shows the current consumption of the cgroup and its
>     descendants, in bytes.
>
>   - memory.low configures the lower end of the cgroup's expected
>     memory consumption range.  The kernel considers memory below that
>     boundary to be a reserve - the minimum that the workload needs in
>     order to make forward progress - and generally avoids reclaiming
>     it, unless there is an imminent risk of entering an OOM situation.

So this is try-hard, but no-promises interface.  No complaints.  But I
assume that an eventual extension is a more rigid memory.min which
specifies a minimum working set under which an container would prefer an
oom kill to thrashing.
