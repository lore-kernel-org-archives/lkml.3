Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaFXVBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:01:24 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55093 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaFXVBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:01:23 -0400
Date: Tue, 24 Jun 2014 17:01:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Message-ID: <20140624210119.GC14909@htj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
 <20140620193521.GB28324@mtj.dyndns.org>
 <53A8D2B8.4080107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A8D2B8.4080107@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Jun 24, 2014 at 09:22:00AM +0800, Li Zefan wrote:
> > Ah, right.  Gees, I'm really hating the fact that we have ->mount but
> > not ->umount.  However, can't we make it a bit simpler by just
> > introducing a mutex protecting looking up and refing up an existing
> > root and a sb going away?  The only problem is that the refcnt being
> > killed isn't atomic w.r.t. new live ref coming up, right?  Why not
> > just add a mutex around them so that they can't race?
> 
> Well, kill_sb() is called with sb->s_umount held, while kernfs_mount()
> returned with sb->s_umount held, so adding a mutex will lead to ABBA
> deadlock.

Hmmm?  Why does that matter?  The only region in cgroup_mount() which
needs to be put inside such mutex would be root lookup, no?

Thanks.

-- 
tejun
