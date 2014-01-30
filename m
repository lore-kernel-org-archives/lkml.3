Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaA3WrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:47:09 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63976 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbaA3WrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:47:07 -0500
Date: Thu, 30 Jan 2014 14:47:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <edumazet@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kthread: ensure locality of task_struct allocations
In-Reply-To: <1391062491.28432.68.camel@edumazet-glaptop2.roam.corp.google.com>
Message-ID: <alpine.DEB.2.02.1401301446320.12223@chino.kir.corp.google.com>
References: <20140128183808.GB9315@linux.vnet.ibm.com> <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com> <alpine.DEB.2.10.1401290957350.23856@nuc> <alpine.DEB.2.02.1401291622550.22974@chino.kir.corp.google.com>
 <1391062491.28432.68.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, Eric Dumazet wrote:

> > Eric, did you try this when writing 207205a2ba26 ("kthread: NUMA aware 
> > kthread_create_on_node()") or was it always numa_node_id() from the 
> > beginning?
> 
> Hmm, I think I did not try this, its absolutely possible NUMA_NO_NODE
> was better here.
> 

Nishanth, could you change your patch to just return NUMA_NO_NODE for the 
non-kthreadd case?
