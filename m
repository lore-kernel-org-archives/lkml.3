Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936479Ab3DRSX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:23:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:10208 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab3DRSXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:23:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,503,1363158000"; 
   d="scan'208";a="321292760"
Date: Thu, 18 Apr 2013 20:23:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/12]  Driver for Si476x series of chips
Message-ID: <20130418182305.GA27841@zurbaran>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
 <20130418142800.5c00b004@redhat.com>
 <20130418174547.GV8798@zurbaran>
 <20130418145753.7bacee9b@redhat.com>
 <20130418181718.GX8798@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418181718.GX8798@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:17:18PM +0200, Samuel Ortiz wrote:
> On Thu, Apr 18, 2013 at 02:57:53PM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 18 Apr 2013 19:45:47 +0200
> > Samuel Ortiz <sameo@linux.intel.com> escreveu:
> > 
> > > On Thu, Apr 18, 2013 at 02:28:00PM -0300, Mauro Carvalho Chehab wrote:
> > > > Em Thu, 18 Apr 2013 09:58:26 -0700
> > > > Andrey Smirnov <andrew.smirnov@gmail.com> escreveu:
> > > > 
> > > > > Driver for Si476x series of chips
> > > > > 
> > > > > This is a eight version of the patchset originaly posted here:
> > > > > https://lkml.org/lkml/2012/9/13/590
> > > > > 
> > > > > Second version of the patch was posted here:
> > > > > https://lkml.org/lkml/2012/10/5/598
> > > > > 
> > > > > Third version of the patch was posted here:
> > > > > https://lkml.org/lkml/2012/10/23/510
> > > > > 
> > > > > Fourth version of the patch was posted here:
> > > > > https://lkml.org/lkml/2013/2/18/572
> > > > > 
> > > > > Fifth version of the patch was posted here:
> > > > > https://lkml.org/lkml/2013/2/26/45
> > > > > 
> > > > > Sixth version of the patch was posted here:
> > > > > https://lkml.org/lkml/2013/2/26/257
> > > > > 
> > > > > Seventh version of the patch was posted here:
> > > > > https://lkml.org/lkml/2013/2/27/22
> > > > > 
> > > > > Eighth version of the patch was posted here:
> > > > > https://lkml.org/lkml/2013/3/26/891
> > > > > 
> > > > > To save everyone's time I'll repost the original description of it:
> > > > > 
> > > > > This patchset contains a driver for a Silicon Laboratories 476x series
> > > > > of radio tuners. The driver itself is implemented as an MFD devices
> > > > > comprised of three parts: 
> > > > >  1. Core device that provides all the other devices with basic
> > > > > functionality and locking scheme.
> > > > >  2. Radio device that translates between V4L2 subsystem requests into
> > > > > Core device commands.
> > > > >  3. Codec device that does similar to the earlier described task, but
> > > > > for ALSA SoC subsystem.
> > > > > 
> > > > > v9 of this driver has following changes:
> > > > >    - MFD part of the driver no longer depends on the header file added
> > > > >      by the radio driver(media/si476x.h) which should potential
> > > > >      restore the bisectability of the patches
> > > > > 
> > > > > Mauro, I am not sure if you reverted changes in patches 5 - 7, so I am
> > > > > including them just in case.
> > > > 
> > > > No, I didn't revert all patches. I just reverted two patches: the
> > > > last one, and the one that Samuel asked me.
> > > Sorry I didn't have time to check your email from yesterday, but I was
> > > actually hoping you would revert the whole patchset, then pull from my
> > > mfd-next/topic/si476x branch to fetch the MFD bits and then apply the
> > > v4l2/media ones (From patchset v9) on top of that.
> > > Does that make sense to you ?
> > 
> > I don't rebase my tree, as this would cause troubles for everybody that
> > relies on it.
> > 
> > Reverting the entire patchset is hard, as there are lots of patches after
> > them, and some patches touch at V4L2 core. Even reverting those
> > two patches hit conflicts, that I needed to manage, in order to avoid
> > compilation breakages.
> > 
> > So, I really prefer to confine the patch reversion to the absolute 
> > minimum.
> In that case we're left with only one solution: Leave your tree as it is (with
> both patches reverted) and push the mfd/Kconfig and mfd/Makefile changes as a
> 3.10 fix. radio/radio-si476x.c should not build without the MFD Kconfig symbol
> so we should be safe. 
You reverted that one, I think this was not needed as it would not build
without the MFD symbol. Any other reason why you reverted it ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
