Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaA1Gxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:53:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbaA1Gxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:53:38 -0500
Date: Tue, 28 Jan 2014 01:53:16 -0500
From: Dave Jones <davej@redhat.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140128065316.GB27636@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tang Chen <tangchen@cn.fujitsu.com>,
	David Rientjes <rientjes@google.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com>
 <52E70165.8070709@cn.fujitsu.com>
 <20140128025537.GA21730@redhat.com>
 <52E722F5.9010505@cn.fujitsu.com>
 <20140128035518.GA25386@redhat.com>
 <52E7364F.5010700@cn.fujitsu.com>
 <20140128044749.GA27164@redhat.com>
 <52E73D61.8000304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E73D61.8000304@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 01:17:21PM +0800, Tang Chen wrote:

 > Seeing from your earlier mail, it crashed at:
 > 
 >                  while (zonelist_zone_idx(z) > highest_zoneidx)
 >    de:   3b 77 08                cmp    0x8(%rdi),%esi
 > 
 > 
 > 	I stuck this at the top of the function..
 > 
 > 	printk(KERN_ERR "z:%p nodes:%p highest:%d\n", z, nodes, highest_zoneidx);
 > 
 > 	and got
 > 
 > 	z: 1d08   nodes: (null)  highest:3
 > 
 > 
 > nodes=null and highest=3, they are correct. When looking into 
 > next_zones_zonelist(),
 > I cannot see why it crashed. So, can you print the zone id in the
 > for_each_zone_zonelist() loop in nr_free_zone_pages() ?
 > I want to know why it crashed. A NULL pointer ?  Which one ?

It's not so easy further in the function, because the oops scrolls off
any useful printks, there's no scrollback, and no logging..
I even tried adding some udelays to slow things down (and using boot_delay)
but that makes things just hang seemingly indefinitly.

What about that 'z' ptr though ? 0x1d08 seems like a strange address
for us to have a structure at, though I'm not too familiar with the early
boot code, so maybe we do have something down there ?

	Dave 

