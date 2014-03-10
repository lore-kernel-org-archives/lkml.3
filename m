Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaCJOUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:20:20 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49144 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaCJOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:20:18 -0400
Date: Mon, 10 Mar 2014 10:20:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] control groups: documentation improvements
Message-ID: <20140310142014.GC25290@htj.dyndns.org>
References: <20140310113928.GC18700@gnimac.gopivotal.com>
 <20140310140724.GA25290@htj.dyndns.org>
 <531DC971.6020208@gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531DC971.6020208@gopivotal.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Mar 10, 2014 at 02:17:21PM +0000, Glyn Normington wrote:
> Then we missed how to create a hierarchy with no associated
> subsystems. The only way I can think of is to use mount, specify no
> subsystems on -o (which defaults to all the subsystems defined in
> the kernel), and run it in a kernel with no subsystems defined
> (which seems unlikely these days).
>
> Is that what you had in mind or is there some other way of creating
> a hierarchy with no subsystems attached?

Hierarchy name should be specified "-o name=" for hierarchies w/o any
controllers.

> >>Clarify that subsystems may be attached to multiple hierarchies,
> >>although this isn't very useful, and explain what happens.
> >And a subsystem may only be attached to a single hierarchy.
>
> Perhaps that's what should happen, but the following experiment
> demonstrates a subsystem being attached to two hierarchies:
> 
> $ pwd
> /home/vagrant
> $ mkdir mem1
> $ mkdir mem2
> $ sudo su
> # mount -t cgroup -o memory none /home/vagrant/mem1
> # mount -t cgroup -o memory none /home/vagrant/mem2
> # cd mem1
> # mkdir inst1
> # ls inst1
> cgroup.clone_children  memory.failcnt ...
> # ls ../mem2
> cgroup.clone_children  inst1 memory.limit_in_bytes ...
> # cd inst1
> # echo 1000000 > memory.limit_in_bytes
> # cat memory.limit_in_bytes
> 1003520
> # cat ../../mem2/inst1/memory.limit_in_bytes
> 1003520
> # echo $$ > tasks
> # cat tasks
> 1365
> 1409
> # cat ../../mem2/inst1/tasks
> 1365
> 1411

You're mounting the same hierarchy twice.  Those are two views into
the same hierarchy.

Thanks.

-- 
tejun
