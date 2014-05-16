Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaEPEq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 00:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbaEPEq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 00:46:58 -0400
Message-ID: <1400215610.3289.174.camel@ul30vt.home>
Subject: Re: [PATCH] i915: Add module option to support VGA arbiter on HD
 devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>
Date: Thu, 15 May 2014 22:46:50 -0600
In-Reply-To: <CAKMK7uGRCQSUNjBiegkYncUiYmFfoLAqxj6UPYJNeOf2S2x-7w@mail.gmail.com>
References: <20140509201655.2849.97478.stgit@bling.home>
	 <20140512190812.GH25056@phenom.ffwll.local>
	 <1399923039.6734.97.camel@bling.home>
	 <20140512193825.GI25056@phenom.ffwll.local>
	 <1400190194.3289.143.camel@ul30vt.home>
	 <CAKMK7uGRCQSUNjBiegkYncUiYmFfoLAqxj6UPYJNeOf2S2x-7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 00:50 +0200, Daniel Vetter wrote:
> On Thu, May 15, 2014 at 11:43 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > I don't know what to do with this.  It seems like a lot of wishful
> > thinking that in the best case would drag on for years.  Even if we get
> > VGA arbitration out of Xorg, the bit about making the userspace VGA
> > arbiter interface lie depending on current->comm sounds tricky and
> > horrible.  If we can lie to Xorg there, why don't we do that now?  If we
> > can't lie to Xorg now, then what deprecation event or detection of the
> > caller is going to allow us to do so in the future?
> 
> Well we wouldn't necessarily need to lie to X, but could instead look
> whether all the vga devices in a system are claimed by kms drivers. If
> that's the case the userspace doesn't have an awful lot of business
> touching the VGA registers and we could simply not obey a vga arb
> request from userspace.
> 
> More advanced would be if we still obey it for those devices not
> claimed by kms drivers. So not really a need to key on current->comm.

This is a requirement for me, I don't really care about KMS or Xorg, the
use case I want to enable is binding a VGA device to vfio-pci so that it
can be assigned to a guest virtual machine.  This works on an unmodified
kernel today so long as you don't have an Intel IGD in your system.  If
you do, we try to switch the VGA device, but it doesn't actually get
switched because i915 opts-out of arbitration yet still claims VGA
accesses.

> > Meanwhile anyone that wants i915 to participate in arbitration like it
> > should have from the start needs to patch their kernel with forward
> > ports of the reverted commits.
> >
> > I just don't see this moving forward, which is why I thought a module
> > option at least gives us a workaround.  Thanks,
> 
> I know that this is awful, but a module option means that the few
> people interested in moving this forward will be happy enough to no
> longer bother. Which is even worse from my pov as driver maintainer. I
> highly consider module options used in production evil.

If I had a solution, I wouldn't be sending this patch :-\  Thanks,

Alex

