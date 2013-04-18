Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935970Ab3DRARa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 20:17:30 -0400
Received: from relay2.sgi.com ([192.48.179.30]:57125 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935849Ab3DRAR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 20:17:28 -0400
Date: Wed, 17 Apr 2013 19:17:26 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v5 5/5] Make reboot_cpuid a kernel parameter.
Message-ID: <20130418001726.GM3658@sgi.com>
References: <1366224198-49485-1-git-send-email-holt@sgi.com>
 <1366224198-49485-6-git-send-email-holt@sgi.com>
 <516EF9DE.6000707@zytor.com>
 <20130417194836.GK3658@sgi.com>
 <516EFF3D.4040506@zytor.com>
 <20130417201533.GL3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130417201533.GL3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 03:15:33PM -0500, Robin Holt wrote:
> On Wed, Apr 17, 2013 at 12:59:57PM -0700, H. Peter Anvin wrote:
> > It is also worth noting that the documentation says reboot=s[mp]#
> > whereas in fact only reboot=s# parse correctly.  I consider this to be a
> > bug.
> > 
> > If we centralized the parser, we could take a string like
> > 
> > "reboot=bios,smp32,warm"
> > 
> > and parse it into:
> > 
> > reboot_cpu = 32
> > reboot_mode = "bw"
> > 
> > ... and pass the information in that form to the arch layer.  I don't
> > think we can do more parsing at that in the main kernel.
> 
> OK.  I will go back to the drawing board again.

There are 4 items being parsed out of reboot= for x86:
 - reboot_mode		w[arm] | c[old]
 - reboot_cpu		s[mp]####
 - reboot_type		b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]
 - reboot_force		f[orce]

This seems like a lot to push into the generic kernel just to make it
appear consistent when there will be no real cross arch consistency.


Contrast that with:
1) New kernel parameter (reboot_cpu) which is clear and concise, uses standard
   parsing methods.
2) Backwards compatibility in that a user with an existing (broken) reboot=s32
   on the command line will set reboot_cpu unless both were specified, in which
   case reboot_cpu takes precedence.

What is so fundamentally wrong with that?  It accomplishes exactly what
you had asked for in that existing users are not broken.  We are introducing
a new functionality in the general kernel.  Why not introduce a new parameter
associated with that functionality.

Thanks,
Robin
