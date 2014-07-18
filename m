Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbaGRSTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:19:53 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:60186 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030567AbaGRSTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:19:51 -0400
Date: Fri, 18 Jul 2014 14:19:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Memoryless nodes and kworker
Message-ID: <20140718181947.GE13012@htj.dyndns.org>
References: <20140717230923.GA32660@linux.vnet.ibm.com>
 <20140718112039.GA8383@htj.dyndns.org>
 <CAOhV88PyBK3WxDjG1H0hUbRhRYzPOzV8eim5DuOcgObe-FtFYg@mail.gmail.com>
 <20140718180008.GC13012@htj.dyndns.org>
 <CAOhV88O03zCsv_3eadEKNv1D1RoBmjWRFNhPjEHawF9s71U0JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhV88O03zCsv_3eadEKNv1D1RoBmjWRFNhPjEHawF9s71U0JA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 18, 2014 at 11:12:01AM -0700, Nish Aravamudan wrote:
> why aren't these callers using kthread_create_on_cpu()? That API was

It is using that.  There just are other data structures too.

> already change to use cpu_to_mem() [so one change, rather than of all over
> the kernel source]. We could change it back to cpu_to_node and push down
> the knowledge about the fallback.

And once it's properly solved, please convert back kthread to use
cpu_to_node() too.  We really shouldn't be sprinkling the new subtly
different variant across the kernel.  It's wrong and confusing.

> Yes, this is a good point. But honestly, we're not really even to the point
> of talking about fallback here, at least in my testing, going off-node at
> all causes SLUB-configured slabs to deactivate, which then leads to an
> explosion in the unreclaimable slab.

I don't think moving the logic inside allocator proper is a huge
amount of work and this isn't the first spillage of this subtlety out
of allocator proper.  Fortunately, it hasn't spread too much yet.
Let's please stop it here.  I'm not saying you shouldn't or can't fix
the off-node allocation.

Thanks.

-- 
tejun
