Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3JDNoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:44:24 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41646 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3JDNoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:44:22 -0400
Date: Fri, 4 Oct 2013 15:44:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Janani Venkataraman <jananive@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, amwang@redhat.com, rdunlap@xenotime.net,
        andi@firstfloor.org, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, suzuki@linux.vnet.ibm.com,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        tarundsk@linux.vnet.ibm.com, vapier@gentoo.org, roland@hack.frob.com,
        tj@kernel.org, ananth@linux.vnet.ibm.com, gorcunov@openvz.org,
        avagin@openvz.org, oleg@redhat.com, eparis@redhat.com,
        d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump
 infrastructure using task_work_add()
Message-ID: <20131004134421.GG6882@two.firstfloor.org>
References: <20131004102532.1612.24185.stgit@f19-x64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 04:00:12PM +0530, Janani Venkataraman wrote:
> Hi all,
> 
> The following series implements an infrastructure for capturing the core of an 
> application without disrupting its process.

The problem is that gcore et.al. have to stop the process briefly
to attach and then use the pid mmap ptrace interfaces, right?

Couldn't they just use the new process_vm_readv() syscalls instead?
AFAIK those do not require ptrace.

Then this could be all done in user space.

Or are there some specific races with this approach?

-Andi

