Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaGLJXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 05:23:35 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:40833 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaGLJXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 05:23:32 -0400
Date: Sat, 12 Jul 2014 11:23:43 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        daniel.vetter@ffwll.ch
Subject: Re: i915: reduce noise from i915_gem_shrinker_oom when no memory
 freed.
Message-ID: <20140712092343.GO17271@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140711030505.GA30830@redhat.com>
 <20140711061143.GQ8986@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711061143.GQ8986@nuc-i3427.alporthouse.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 07:11:43AM +0100, Chris Wilson wrote:
> On Thu, Jul 10, 2014 at 11:05:05PM -0400, Dave Jones wrote:
> > When the shrinker doesn't free any memory, don't spew over and over
> > into the logs.  My fuzz tester hits this quite easily, resulting
> > in dozens of instances of this printk when memory runs low, filling
> > dmesg, when there's not even any graphical stuff going on, so the
> > situation would never change.
> 
> We still want to know when we failed to free anything though.
> 
> if (freed || unbound || bound)
> 	pr_info("Purging GPU memory...
> 
> should be a reasonable compromise.

Dave, would this work for you? Can you please submit it as a patch to
intel-gfx?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
