Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936083Ab3DRBZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 21:25:41 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41936 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935094Ab3DRBZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 21:25:40 -0400
Date: Wed, 17 Apr 2013 20:25:39 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v5 5/5] Make reboot_cpuid a kernel parameter.
Message-ID: <20130418012539.GN3658@sgi.com>
References: <1366224198-49485-1-git-send-email-holt@sgi.com>
 <1366224198-49485-6-git-send-email-holt@sgi.com>
 <516EF9DE.6000707@zytor.com>
 <20130417194836.GK3658@sgi.com>
 <516EFF3D.4040506@zytor.com>
 <20130417201533.GL3658@sgi.com>
 <20130418001726.GM3658@sgi.com>
 <516F40C5.40409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516F40C5.40409@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:39:33PM -0700, H. Peter Anvin wrote:
> On 04/17/2013 05:17 PM, Robin Holt wrote:
> > 
> > There are 4 items being parsed out of reboot= for x86:
> >  - reboot_mode		w[arm] | c[old]
> >  - reboot_cpu		s[mp]####
> >  - reboot_type		b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]
> >  - reboot_force		f[orce]
> > 
> > This seems like a lot to push into the generic kernel just to make it
> > appear consistent when there will be no real cross arch consistency.
> > 
> > Contrast that with:
> > 1) New kernel parameter (reboot_cpu) which is clear and concise, uses standard
> >    parsing methods.
> > 2) Backwards compatibility in that a user with an existing (broken) reboot=s32
> >    on the command line will set reboot_cpu unless both were specified, in which
> >    case reboot_cpu takes precedence.
> > 
> > What is so fundamentally wrong with that?  It accomplishes exactly what
> > you had asked for in that existing users are not broken.  We are introducing
> > a new functionality in the general kernel.  Why not introduce a new parameter
> > associated with that functionality.
> > 
> 
> You are confusing implementation with interface.  That is what is so
> fundamentally wrong with that.  You really, really don't want to change
> interface unless the world will end if you don't.
> 
> As far as why centralize -- the main concern I have is that someone
> might try to introduce an arch-specific reboot= which is *syntactically*
> different, which is yet again really awful from a user perspective.

Yes and no.  I am saying that the interface is garbage and already
specified as arch specific.  You are asking me to take that garbage
interface and promote it to a general interface which will force us to
implement it in a completely crappy way.

Compare that with introducing a new interface which is concise and then
providing backwards compatibility.  Add to that the fact, I don't need
to pollute the kernel with some poorly done x86 interface and leave that
cruft for others to clean up.

Thanks,
Robin
