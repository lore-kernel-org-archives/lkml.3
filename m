Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3B0V0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:26:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3B0V0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:26:15 -0500
Date: Wed, 27 Feb 2013 13:26:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
Message-Id: <20130227132612.14664a3a.akpm@linux-foundation.org>
In-Reply-To: <512DBD24.7090302@cn.fujitsu.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D58C2.1090403@jp.fujitsu.com>
	<CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>
	<512D7FAD.1040003@jp.fujitsu.com>
	<CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>
	<512D8EDA.3010602@jp.fujitsu.com>
	<CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
	<512DBD24.7090302@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013 16:00:36 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> In the mails and the changlog of the revert-patch, I think Yinghai
> mainly worries about 3 problems.
> 
> 1) the current implement has bug and bad code.
> 
> 	Yes. Any bug should be fixed. we should fix it directly, or
> 	we can revert the related patches and then send the fixed patches.
> 
> 	But the related patch is only one or two, it is not good idea
> 	to revert the whole patchset or the whole feature. Right?

Reverting a new patchset isn't really a big deal.  The patchset gets
fixed up, retested then reapplied.  We like to do things this way
because it minimises the amount of trouble which the regression is
causing other people.

Reverting one or two patches from a fairly large and complex patchset
sounds risky - we're putting an untested patch combination straight
into mainline with minimal testing.  It would be safer to revert
everything.

So I'm thinking that the best approach here is to revert everything and
then try again for 3.10-rc1.  This gives people time to test the code
while it's only in linux-next.  (Hint!)

> 	Thank you all for addressing the bug. we are on the way to fix it.

How long do you think this will take?

> 2) many memory can be put into hotplugable memory, but we have not yet moved them
>    into hotplugable memory yet. like: vmemmap, some page table ...etc, a lot.
> 
> 	This is a restriction in the currently kernel, we can't convert them quickly.
> 	we must convert them step by step. example, we are converting the memory of
> 	page_cgroup to hotplugable memory.
> 
> 
> 3) if the user(or firmware) specify the un-hotplugable memory too small, the system can't
>    work, even can't boot.
> 
> 	Any feature/system has its own minimum requirements, the user should
> 	meet the requirements and specify more un-hotplugable memory.
> 	so I don't think it is a problem in kernel land.
> 
> 	But the problem 2)(above) make this feature's "minimum requirements"
> 	much higher. It is the real thing that Yinghai worries about.
> 
> 	But all systems which use this feature can offer this higher requirement
> 	very easily. The users should specify enough un-hotplugable memory
> 	before and after we decrease the "minimum requirements".
> 
> 	The whole feature works very well if the user specify enough
> 	un-hotplugable memory. So the problem 2) and 3) are not urgent
> 	problems.

Yes, let's not mingle concepts.  From a feature perspective we've
always understood that 3.9 memory hotplug would be "has limitations,
needs work, but better than it was before".  Let's consider that
separately from "your patchset broke my kernel".

