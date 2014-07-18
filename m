Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945940AbaGRS6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:58:35 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45085 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbaGRS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:58:33 -0400
Date: Fri, 18 Jul 2014 14:58:29 -0400
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
Message-ID: <20140718185829.GF13012@htj.dyndns.org>
References: <20140717230923.GA32660@linux.vnet.ibm.com>
 <20140718112039.GA8383@htj.dyndns.org>
 <CAOhV88PyBK3WxDjG1H0hUbRhRYzPOzV8eim5DuOcgObe-FtFYg@mail.gmail.com>
 <20140718180008.GC13012@htj.dyndns.org>
 <CAOhV88O03zCsv_3eadEKNv1D1RoBmjWRFNhPjEHawF9s71U0JA@mail.gmail.com>
 <20140718181947.GE13012@htj.dyndns.org>
 <CAOhV88Mby_vrLPtRsRNO724-_ABEL06Fc1mMwjgq7LWw-uxeAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhV88Mby_vrLPtRsRNO724-_ABEL06Fc1mMwjgq7LWw-uxeAw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 18, 2014 at 11:47:08AM -0700, Nish Aravamudan wrote:
> Why are any callers of the format kthread_create_on_node(...,
> cpu_to_node(cpu), ...) not using kthread_create_on_cpu(..., cpu, ...)?

Ah, okay, that's because unbound workers are NUMA node affine, not
CPU.

> It seems like an additional reasonable approach would be to provide a
> suitable _cpu() API for the allocators. I'm not sure why saying that
> callers should know about NUMA (in order to call cpu_to_node() in every
> caller) is any better than saying that callers should know about memoryless
> nodes (in order to call cpu_to_mem() in every caller instead) -- when at

It is better because that's what they want to express - "I'm on this
memory node, please allocate memory on or close to this one".  That's
what the caller cares about.  Calling with cpu could be an option but
you'll eventually run into cases where you end up having to map back
NUMA node id to a CPU on it, which will probably feel at least a bit
silly.  There are things which really are per-NUMA node.

So, let's please express what needs to be expressed.  Massaging around
it can be useful at times but that doesn't seem to be the case here.

Thanks.

-- 
tejun
