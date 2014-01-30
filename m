Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaA3Xbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:31:50 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44349 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaA3Xbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:31:49 -0500
Date: Thu, 30 Jan 2014 15:31:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Christoph Lameter <cl@linux.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kthread: ensure locality of task_struct allocations
In-Reply-To: <20140130230812.GA874@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1401301531280.16167@chino.kir.corp.google.com>
References: <20140128183808.GB9315@linux.vnet.ibm.com> <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com> <alpine.DEB.2.10.1401290957350.23856@nuc> <alpine.DEB.2.02.1401291622550.22974@chino.kir.corp.google.com>
 <1391062491.28432.68.camel@edumazet-glaptop2.roam.corp.google.com> <alpine.DEB.2.02.1401301446320.12223@chino.kir.corp.google.com> <20140130230812.GA874@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Nishanth Aravamudan wrote:

> In the presence of memoryless nodes, numa_node_id() will return the
> current CPU's NUMA node, but that may not be where we expect to allocate
> from memory from. Instead, we should rely on the fallback code in the
> memory allocator itself, by using NUMA_NO_NODE. Also, when calling
> kthread_create_on_node(), use the nearest node with memory to the cpu in
> question, rather than the node it is running on.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
