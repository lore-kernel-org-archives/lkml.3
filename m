Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaI3Ou6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:50:58 -0400
Received: from mx.treblig.org ([80.68.94.177]:44565 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaI3Ou4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:50:56 -0400
Date: Tue, 30 Sep 2014 15:50:55 +0100
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Marcin Gibula <m.gibula@gmail.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com
Subject: Re: 3.16.1 - general protection fault
Message-ID: <20140930145055.GA24978@gallifrey>
References: <CAGKO+35+H3MmkaN1m_PfHi0XhbRvtnSBqm3PDmOhs5YBmAZ1jg@mail.gmail.com>
 <20140924201827.GA30643@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924201827.GA30643@gallifrey>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/3.2.60-kvm-i386-20140609 (i686)
X-Uptime: 15:50:16 up 67 days, 22:14,  1 user,  load average: 0.01, 0.04, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dr. David Alan Gilbert (dave@treblig.org) wrote:
> * Marcin Gibula (m.gibula@gmail.com) wrote:
> 
> Hi Marcin,
> 
> > Hi,
> > 
> > I've been playing with 3.16 kernel on my test machine as a KVM
> > hypervisor and encountered the following crash twice (almost identical
> > backtraces).
> > 
> > Sep 24 09:39:31 dev4 kernel: general protection fault: 0000 [#1] SMP
> 
> <snip>
> 
> > This machine is serving as NFS client and KVM hypervisor. I'm still
> > not sure how to trigger it reliably (right now, I just have to run
> > ubuntu instalation in VM guest multiple times and sometimes it
> > triggers).
> > 
> > Attaching .config, slub.s and disassembled __kmalloc_node_track_caller function.
> 
> Yes, I hit something similar:
> 
> http://www.spinics.net/lists/linux-nfs/msg46047.html 'nfs: disallow duplicate pages in pgio page vectors'
> http://www.spinics.net/lists/linux-nfs/msg46048.html 'nfs: can_coalesce_requests must enforce contiguity'
> 
> seem to stop the GPF's/crashes, although there's still something else
> going on with a corruption I'm seeing every so often.

And that 'something else' seems to be fixed by:

http://marc.info/?l=linux-nfs&m=141208464631105&w=2

Enjoy,

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
