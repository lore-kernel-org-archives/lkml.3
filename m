Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3DRR6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab3DRR57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:57:59 -0400
Date: Thu, 18 Apr 2013 14:57:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/12]  Driver for Si476x series of chips
Message-ID: <20130418145753.7bacee9b@redhat.com>
In-Reply-To: <20130418174547.GV8798@zurbaran>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
	<20130418142800.5c00b004@redhat.com>
	<20130418174547.GV8798@zurbaran>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 18 Apr 2013 19:45:47 +0200
Samuel Ortiz <sameo@linux.intel.com> escreveu:

> On Thu, Apr 18, 2013 at 02:28:00PM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 18 Apr 2013 09:58:26 -0700
> > Andrey Smirnov <andrew.smirnov@gmail.com> escreveu:
> > 
> > > Driver for Si476x series of chips
> > > 
> > > This is a eight version of the patchset originaly posted here:
> > > https://lkml.org/lkml/2012/9/13/590
> > > 
> > > Second version of the patch was posted here:
> > > https://lkml.org/lkml/2012/10/5/598
> > > 
> > > Third version of the patch was posted here:
> > > https://lkml.org/lkml/2012/10/23/510
> > > 
> > > Fourth version of the patch was posted here:
> > > https://lkml.org/lkml/2013/2/18/572
> > > 
> > > Fifth version of the patch was posted here:
> > > https://lkml.org/lkml/2013/2/26/45
> > > 
> > > Sixth version of the patch was posted here:
> > > https://lkml.org/lkml/2013/2/26/257
> > > 
> > > Seventh version of the patch was posted here:
> > > https://lkml.org/lkml/2013/2/27/22
> > > 
> > > Eighth version of the patch was posted here:
> > > https://lkml.org/lkml/2013/3/26/891
> > > 
> > > To save everyone's time I'll repost the original description of it:
> > > 
> > > This patchset contains a driver for a Silicon Laboratories 476x series
> > > of radio tuners. The driver itself is implemented as an MFD devices
> > > comprised of three parts: 
> > >  1. Core device that provides all the other devices with basic
> > > functionality and locking scheme.
> > >  2. Radio device that translates between V4L2 subsystem requests into
> > > Core device commands.
> > >  3. Codec device that does similar to the earlier described task, but
> > > for ALSA SoC subsystem.
> > > 
> > > v9 of this driver has following changes:
> > >    - MFD part of the driver no longer depends on the header file added
> > >      by the radio driver(media/si476x.h) which should potential
> > >      restore the bisectability of the patches
> > > 
> > > Mauro, I am not sure if you reverted changes in patches 5 - 7, so I am
> > > including them just in case.
> > 
> > No, I didn't revert all patches. I just reverted two patches: the
> > last one, and the one that Samuel asked me.
> Sorry I didn't have time to check your email from yesterday, but I was
> actually hoping you would revert the whole patchset, then pull from my
> mfd-next/topic/si476x branch to fetch the MFD bits and then apply the
> v4l2/media ones (From patchset v9) on top of that.
> Does that make sense to you ?

I don't rebase my tree, as this would cause troubles for everybody that
relies on it.

Reverting the entire patchset is hard, as there are lots of patches after
them, and some patches touch at V4L2 core. Even reverting those
two patches hit conflicts, that I needed to manage, in order to avoid
compilation breakages.

So, I really prefer to confine the patch reversion to the absolute 
minimum.

-- 

Cheers,
Mauro
