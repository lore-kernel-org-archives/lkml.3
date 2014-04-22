Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbaDVUbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:31:36 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:47039 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbaDVUbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:31:31 -0400
Date: Tue, 22 Apr 2014 16:31:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] cgroup: introduce helper css_to_id()
Message-ID: <20140422203126.GD2314@mtj.dyndns.org>
References: <cover.1398147734.git.nasa4836@gmail.com>
 <0414ce4418a6f0dd481586ce4059b97800bcc1ca.1398147734.git.nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0414ce4418a6f0dd481586ce4059b97800bcc1ca.1398147734.git.nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:30:27PM +0800, Jianyu Zhan wrote:
> This is a prepared patch for converting from per-cgroup id to
> per-subsystem id.
> 
> Some subsystems dereference the per-cgrpu id directly, but this is
> implementation-specific, so it should be transparent for subsystems.

Hmm... why would cgroup ID be implementation-specific?  It's a
published field

> Use this accessor instead.

I'm not a big believer of trivial accessors.  They tend to obfuscate
things more than helping anything.  Here, we need to switch from
cgrp->id to css->id.  Wrapping cgrp->id by css_to_id() doesn't really
help anything especially because there will be cases where we'd
actually want cgroup IDs instead of css IDs too.

Thanks.

-- 
tejun
