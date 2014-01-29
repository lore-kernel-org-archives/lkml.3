Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaA2P5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:57:38 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:44500 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbaA2P5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:57:37 -0500
Date: Wed, 29 Jan 2014 09:57:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kthread: ensure locality of task_struct allocations
In-Reply-To: <20140128183808.GB9315@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1401290956060.23856@nuc>
References: <20140128183808.GB9315@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Nishanth Aravamudan wrote:

> In the presence of memoryless nodes, numa_node_id()/cpu_to_node() will
> return the current CPU's NUMA node, but that may not be where we expect
> to allocate from memory from. Instead, we should use
> numa_mem_id()/cpu_to_mem(). On one ppc64 system with a memoryless Node
> 0, this ends up saving nearly 500M of slab due to less fragmentation.

Reviewed-by: Christoph Lameter <cl@linux.com>
