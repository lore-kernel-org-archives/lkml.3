Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbaA1Vpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:45:30 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:34148 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbaA1Vp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:45:28 -0500
Date: Tue, 28 Jan 2014 16:45:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Li Zefan <lizefan@huawei.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup filter")
Message-ID: <20140128214524.GA16060@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andi, Wu.

Can you guys please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup
filter"), which reaches into cgroup to extract the inode number and
uses that for filtering?  Nobody outside cgroup proper should be
reaching into that.  In fact, the hard association between vfs objects
and cgroup objects are going away in the upcoming devel cycle.  If you
want to tag on memcg for filtering, please introduce a proper memcg
knob.

Thank you.

-- 
tejun
