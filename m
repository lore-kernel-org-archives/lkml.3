Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3EBCT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:19:29 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54121 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab3EBCT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:19:26 -0400
Date: Wed, 1 May 2013 21:19:23 -0500
From: Robin Holt <holt@sgi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v7 0/11] Shutdown from reboot_cpuid without stopping
 other cpus.
Message-ID: <20130502021923.GS3672@sgi.com>
References: <1367428011-17123-1-git-send-email-holt@sgi.com>
 <20130501231347.GT14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501231347.GT14496@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 12:13:47AM +0100, Russell King - ARM Linux wrote:
> On Wed, May 01, 2013 at 12:06:40PM -0500, Robin Holt wrote:
> > Andrew, Please do _NOT_ take this patch series yet.  I am sending this
> > to you because you had comments on my -v6 submission.
> 
> Another reason for not applying this is that I believe it wilfully breaks
> a bunch of ARM platforms - such as removing the 'g' reboot mode (for gpio
> based reboot on PXA), and removing the 's' reboot mode off a bunch of ARM
> platforms which have no way to do a hard reboot.
> 
> What scares me is that this is revision 7 of this patch set and this is
> the first it's been noticed on ARM... Maybe this patch set didn't touch
> ARM previously?

It started with a simple add a CONFIG_ value which eliminated the
calls to offline all cpus.  That expanded to the migrate to cpu 0.
Then the suggestion was to make a kernel parameter for selecting which
cpu to migrate to.  That led to discovering x86's reboot=s## parameter.
That led to move that to generic code, which led to resolving the conflict
between arm, unicore32, and x86 and therefore, this patch series.

If I had my preference, I would go back to -v2, polish it a bit,
and resubmit.  It just put the migrate_to_boot_cpu in kernel/sys.c,
put the calls in place, and continued with shutdown.

Second choice would be -v4 which added a reboot_cpu (actually, then it
was reboot_cpuid, but I would make it reboot_cpu) core_param, fixed the
x86 reboot=s## handling to handle more than the first 100 cpus and also
the documented smp## syntax.  I would not twiddle with unicore32 or arm.

Bottom line, the first 5 patches in this series are what I really care
about.  They get me the ability to shut my machine down in under 15
minutes.  The rest is just stuff I am doing to gain acceptance for those.

Robin
