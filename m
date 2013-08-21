Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab3HUOB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:01:57 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:39654 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3HUOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:01:56 -0400
Date: Wed, 21 Aug 2013 10:01:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 06/11] cpuset: apply cs->real_{cpus,mems}_allowed
Message-ID: <20130821140151.GF19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148F9C.2080600@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148F9C.2080600@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 05:59:56PM +0800, Li Zefan wrote:
> Now we can use cs->real{cpus,mems}_allowed as effective masks. It's
> used whenever:
> 
> - we update tasks' cpus_allowed/mems_allowed,
> - we want to retrieve tasks_cs(tsk)'s cpus_allowed/mems_allowed.
> 
> They actually replace effective_{cpu,node}mask_cpuset().

I think it'd be great if this and the previous patch descriptions
explain that the effective masks equal configured sans the offline
cpus / mems except when the result is empty, in which case it takes on
the nearest ancestor whose intersection isn't empty, and that the
result equals the computed masks from
effective_{cpu,node}mask_cpuset().

Thanks.

-- 
tejun
