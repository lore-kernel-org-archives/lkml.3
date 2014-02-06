Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbaBFS72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:59:28 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62168 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaBFS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:59:27 -0500
Date: Thu, 6 Feb 2014 19:59:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Attaching a cgroup subsystem to multiple hierarchies
Message-ID: <20140206185923.GA2781@dhcp22.suse.cz>
References: <050BD595-BE55-401D-9B61-E877FB9F06A8@gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <050BD595-BE55-401D-9B61-E877FB9F06A8@gopivotal.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-02-14 14:39:52, Glyn Normington wrote:
> Reading cgroups.txt and casting around the net leads me to believe
> that it is possible to attach a cgroup subsystem (e.g. memory) to
> multiple hierarchies, but this seems to result in “mirrored”
> hierarchies which are automatically kept in step with each other -
> essentially it looks like the same hierarchy at multiple file system
> paths.
> 
> Take the following interaction for example:
> 
> \begin{verbatim}
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
> 
> Is this working as intended?

Yes, it doesn't make any sense to have two different views on the same
controllers.

> Is there some other way to attach a subsystem to *distinct*
> hierarchies?

No.

> Distinct hierarchies would allow distinct cgroups, distinct settings
> (e.g. memory.limit_in_bytes) and distinct partitions of the tasks in
> the system.

Which one should be applied then?

> 
> Note: I don’t have a good use for this function - I’m simply
> trying to reverse engineer the semantics of cgroups to get a precise
> understanding.

I think there is no need to reverse engineer ;)
Documentation/cgroups/cgroups.txt in the kernel tree does give a decent
description IMO.

-- 
Michal Hocko
SUSE Labs
