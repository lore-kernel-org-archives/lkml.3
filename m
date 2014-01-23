Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaAWOln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:41:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaAWOlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:41:42 -0500
Date: Thu, 23 Jan 2014 01:58:24 -0500
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140123065824.GA17684@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
 <20140123061343.GB15206@redhat.com>
 <alpine.DEB.2.02.1401222214290.8088@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401222214290.8088@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:15:51PM -0800, David Rientjes wrote:
 > On Thu, 23 Jan 2014, Dave Jones wrote:
 > 
 > > It's 10, because I had MAXSMP set.
 > > 
 > > So, MAX_NUMNODES = 1 << 10
 > > 
 > > And the bitmask is made of longs. 1024 of them.
 > > 
 > > How does this work ?
 > > 
 > 
 > It's 1024 bits.

ok, I got lost in the maze of macros.

128 bytes is a pretty small amount of stack though, so I'm just as confused
as to what the actual bug here is.


After trying the proposed fix, I got another oops in the early init code..

<trace>
nr_free_zone_pages
nr_free_pagecache_pages
build_all_zonelists
start_kernel
<rip> ffffffffbc164b1e next_zones_zonelist
<rsp> ffffffffbcc01f00

I'll poke at it more in the morning. Too sleepy.

	Dave

