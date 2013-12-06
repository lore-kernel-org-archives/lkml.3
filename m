Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab3LFQZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:25:10 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:52833 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3LFQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:25:07 -0500
Date: Fri, 6 Dec 2013 11:25:03 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Message-ID: <20131206162503.GD13373@htj.dyndns.org>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com>
 <20131205211814.GA29598@mtj.dyndns.org>
 <52A1766F.5090808@parallels.com>
 <20131206161312.GC13373@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206161312.GC13373@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 11:13:12AM -0500, Tejun Heo wrote:
> > Second, it's not clear to me why we need the CSS_ONLINE flag at all if
> > we never assign css's that we fail to online to a cgroup. AFAIU we will
> > never see such css's, because in all places we call offline_css(),
> > namely cgroup_destroy_locked() (via kill_css()) and
> > cgroup_unload_subsys(), we use cgroup_css() which will return NULL for them.
> 
> The whole thing is in flux and will look very different in near
> future.  I actually had patches queued which deal with the issue you
> spotted but they are being blocked on other changes ATM.  So, yeah,
> there are some spurious stuff now.

LOL, I found the patch.  It was posted and acked I just forgot to
apply the whole series.  I'm a moron.

  http://permalink.gmane.org/gmane.linux.kernel.containers/26804

This should do it, right?  I'll update the patch description and
repost the series.

Thanks!

-- 
tejun
