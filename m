Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3HMPFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:05:55 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:43016 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab3HMPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:05:53 -0400
Date: Tue, 13 Aug 2013 11:05:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write
 functions
Message-ID: <20130813150549.GF26596@mtj.dyndns.org>
References: <5209892D.8070502@huawei.com>
 <52098941.4070600@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52098941.4070600@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 09:17:53AM +0800, Li Zefan wrote:
> Now cgroup core gets a reference to the css when a cgroup file is
> opened(), and the reference is dropped at file release. so it's
> guaranteed the cpuset is online during the write function.

Hmmm... it doesn't really guarantee that as css's can be offlined with
residual css refcnts, os the css may well be offlined by the time it
reaches the rw functions.  What's guaranteed is that their refcnts
wouldn't be zero.  Eventually we need to implement proper sever
semantics (probably by replacing the custom fs implementation with
sysfs) but right now controllers still need to deal with offline
css's.

Thanks.

-- 
tejun
