Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaGLPuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 11:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaGLPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 11:50:35 -0400
Date: Sat, 12 Jul 2014 11:50:25 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: i915: reduce noise from i915_gem_shrinker_oom when no memory
 freed.
Message-ID: <20140712155025.GA2122@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140711030505.GA30830@redhat.com>
 <20140711061143.GQ8986@nuc-i3427.alporthouse.com>
 <20140712092343.GO17271@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712092343.GO17271@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 11:23:43AM +0200, Daniel Vetter wrote:
 > On Fri, Jul 11, 2014 at 07:11:43AM +0100, Chris Wilson wrote:
 > > On Thu, Jul 10, 2014 at 11:05:05PM -0400, Dave Jones wrote:
 > > > When the shrinker doesn't free any memory, don't spew over and over
 > > > into the logs.  My fuzz tester hits this quite easily, resulting
 > > > in dozens of instances of this printk when memory runs low, filling
 > > > dmesg, when there's not even any graphical stuff going on, so the
 > > > situation would never change.
 > > 
 > > We still want to know when we failed to free anything though.
 > > 
 > > if (freed || unbound || bound)
 > > 	pr_info("Purging GPU memory...
 > > 
 > > should be a reasonable compromise.
 > 
 > Dave, would this work for you? Can you please submit it as a patch to
 > intel-gfx?

Will do when I get back on Monday.  I'm running my tests over the
weekend, looks ok so far.

thanks,

	Dave
