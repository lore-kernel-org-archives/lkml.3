Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaBLGKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:10:44 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58194 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbaBLGKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:10:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAHAMoP+1J5LJLw/2dsb2JhbABagwy6ZYVQgRAXdIIlAQEFOhwzCAMYCSUPBSUDIQESiATJJRcWjmqDJIEUBJgpik+HUoNBKA
Date: Wed, 12 Feb 2014 17:10:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212061038.GC13997@dastard>
References: <20140211172707.GA1749@redhat.com>
 <20140211210841.GM13647@dastard>
 <52FA9ADA.9040803@sandeen.net>
 <20140212004403.GA17129@redhat.com>
 <20140212010941.GM18016@ZenIV.linux.org.uk>
 <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
 <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <20140212055027.GA28502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212055027.GA28502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:50:27AM -0500, Dave Jones wrote:
> On Wed, Feb 12, 2014 at 04:40:43PM +1100, Dave Chinner wrote:
> 
>  > None of the XFS code disables interrupts in that path, not does is
>  > call outside XFS except to dispatch IO. The stack is pretty deep at
>  > this point and I know that the standard (non stacked) IO stack can
>  > consume >3kb of stack space when it gets down to having to do memory
>  > reclaim during GFP_NOIO allocation at the lowest level of SCSI
>  > drivers. Stack overruns typically show up with symptoms like we are
>  > seeing.
>  > ..
>  > 
>  > Dave, before chasing ghosts, can you (like Eric originally asked)
>  > turn on stack overrun detection?
> 
> CONFIG_DEBUG_STACKOVERFLOW ? Already turned on.

That only checks stack usage when an interrupt is taken. If no
interrupts are taken when stack usage is within 128 bytes of
overflow, then it doesn't catch it.

I tend to use CONFIG_DEBUG_STACK_USAGE=y as it records the maximum
stack usage of a process via canary overwrites and it records it in
do_exit(). I also use the stack tracer to record the largest stack
usage seen so I know exactly what code paths are approaching stack
overruns...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
