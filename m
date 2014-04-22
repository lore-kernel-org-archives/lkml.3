Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbaDVUgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:36:44 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:50690 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbaDVUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:36:41 -0400
Date: Tue, 22 Apr 2014 16:36:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] cgroup: convert from per-cgroup id to per-subsys id
Message-ID: <20140422203632.GF2314@mtj.dyndns.org>
References: <cover.1398147734.git.nasa4836@gmail.com>
 <f478e92038bfbc1da2d03082641804e8acfdfad3.1398153537.git.nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f478e92038bfbc1da2d03082641804e8acfdfad3.1398153537.git.nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 04:03:31PM +0800, Jianyu Zhan wrote:
> Hi, all.
> 
> Sorry, previous patch has a minor fault, and cause a unitialized variable warning.
> I've fixed it up in this.
> 
> Renewed patch:
> ---
> 
> Currently, cgrp->id is only used to look up css's.  As cgroup and
> css's lifetimes is now decoupled, it should be made per-subsystem
> and moved to css->css_id so that lookups are successful until the
> target css is released.

So, css ID can't replace cgroup ID as whole.  It's just that there are
cases where we're currently using cgroup IDs where we should be using
css IDs.  Also, we need to update css creation error path RCU safe so
that idr lookup is always RCU safe.  I already had patches queued for
posting.  Will post them soon.

Thanks.

-- 
tejun
