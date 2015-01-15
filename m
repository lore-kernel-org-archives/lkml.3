Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbbAOSzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:55:49 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50789 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbAOSzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:55:47 -0500
Date: Thu, 15 Jan 2015 13:55:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, koct9i@gmail.com
Subject: Re: [PATCH 3/6] memcg: track shared inodes with dirty pages
Message-ID: <20150115185543.GA28195@htj.dyndns.org>
References: <20150115180242.10450.92.stgit@buzz>
 <20150115184914.10450.51964.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115184914.10450.51964.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:49:14PM +0300, Konstantin Khebnikov wrote:
> From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> 
> Inode is owned only by one memory cgroup, but if it's shared it might
> contain pages from multiple cgroups. This patch detects this situation
> in memory reclaiemer and marks dirty inode with flag I_DIRTY_SHARED
> which is cleared only when data is completely written. Memcg writeback
> always writes such inodes.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

This conflicts with the writeback cgroup support patchset which will
solve the writeback and memcg problem a lot more comprehensively.

 http://lkml.kernel.org/g/1420579582-8516-1-git-send-email-tj@kernel.org

Thanks.

-- 
tejun
