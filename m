Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaGKGMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:12:00 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:63664 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751235AbaGKGL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:11:58 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Fri, 11 Jul 2014 07:11:43 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        daniel.vetter@ffwll.ch
Subject: Re: i915: reduce noise from i915_gem_shrinker_oom when no memory
 freed.
Message-ID: <20140711061143.GQ8986@nuc-i3427.alporthouse.com>
References: <20140711030505.GA30830@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711030505.GA30830@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:05:05PM -0400, Dave Jones wrote:
> When the shrinker doesn't free any memory, don't spew over and over
> into the logs.  My fuzz tester hits this quite easily, resulting
> in dozens of instances of this printk when memory runs low, filling
> dmesg, when there's not even any graphical stuff going on, so the
> situation would never change.

We still want to know when we failed to free anything though.

if (freed || unbound || bound)
	pr_info("Purging GPU memory...

should be a reasonable compromise.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
