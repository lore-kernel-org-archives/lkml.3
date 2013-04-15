Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3DOBNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:13:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3DOBNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:13:43 -0400
Date: Sun, 14 Apr 2013 20:13:36 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, vgoyal@redhat.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: force use_hierarchy if sane_behavior
Message-ID: <20130415011336.GF8408@sergelap>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
 <1365808259-31073-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365808259-31073-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Turn on use_hierarchy by default if sane_behavior is specified and
> don't create .use_hierarchy file.
> 
> It is debatable whether to remove .use_hierarchy file or make it ro as
> the former could make transition easier in certain cases; however, the
> behavior changes which will be gated by sane_behavior are intensive
> including changing basic meaning of certain control knobs in a few
> controllers and I don't really think keeping this piece would make
> things easier in any noticeable way, so let's remove it.

Hi Tejun,

this actually reminds me of something that's been on my todo list to
report for some time, but I haven't had time to find the source of the
bug...  And maybe it's already been reported...  but

If I do

	cd /sys/fs/cgroup/memory
	mkdir b
	cd b
	echo 1 > memory.use_hierarchy
	echo 5000 > memory.limit_in_bytes
	cat memory.limit_in_bytes
8192
	mkdir c
	cd c
	cat memory.use_hierarchy
1
	cat memory.limit_in_bytes
9223372036854775807
	echo $$ > tasks
	bash
<killed>

So it seems the hierarchy is being enforced, but not reported in
child limit_in_bytes files.

(Last tested tonight on 3.8.0-17-generic #27-Ubuntu fwiw)

-serge
