Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3FNLmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 07:42:23 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37581 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3FNLmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 07:42:21 -0400
Date: Fri, 14 Jun 2013 13:41:18 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 01/31] MIPS: Move allocate_kscratch to cpu-probe.c and
 make it public.
Message-ID: <20130614114118.GD15775@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-2-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-2-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:05PM -0700, David Daney wrote:
> Date:   Fri,  7 Jun 2013 16:03:05 -0700
> From: David Daney <ddaney.cavm@gmail.com>
> To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
>  Sanjay Lal <sanjayl@kymasys.com>
> Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
> Subject: [PATCH 01/31] MIPS: Move allocate_kscratch to cpu-probe.c and make
>  it public.
> 
> From: David Daney <ddaney@caviumnetworks.com>

I'd just like to add a note about compatibility.  Code optimized for
LL/SC-less CPUs has made use of the fact that exception handlers will
clobber k0/k1 to a non-zero value.  On a MIPS II or better CPU a branch
likely instruction could be used to atomically test k0/k1 and depending
on the test, execute a store instruction like:

	.set	noreorder
	beqzl	$k0, ok
	sw	$reg, offset($reg)
	/* if we get here, our SC emulation has failed  */
ok:	...

In particular Sony had elected to do this for the R5900 (after I explained
the concept to somebody and told it'd be a _bad_ idea for compatibility
reasons).  Bad ideas are infectious so I'm sure others have used it, too.

I don't think this should stop your patch nor should we unless this turns
out to be an actual problem add any kludges to support such cowboy style
hacks.  But I wanted to mention and document the issue; maybe this should
be mentioned in the log message of the next version of this patch.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
