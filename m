Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3DMT1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 15:27:08 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37063 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3DMT1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 15:27:06 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Heads up on a device tree change
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <511382AD.7030804@imgtec.com>
References: <CACxGe6sCBCGfLDAGVRgP3cnmE+oyXBDdPeVXVCqrsvCh13yPiw@mail.gmail.com> <51125B56.9050407@imgtec.com> <CACxGe6vuZ2H-G7xamS6SAiX_aCbjpO+vKavqCK77ek8tTdOmdA@mail.gmail.com> <511382AD.7030804@imgtec.com>
Date: Sat, 13 Apr 2013 20:26:59 +0100
Message-Id: <20130413192659.D92973E2249@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 10:32:13 +0000, James Hogan <james.hogan@imgtec.com> wrote:
> On 06/02/13 14:28, Grant Likely wrote:
> > On Wed, Feb 6, 2013 at 1:32 PM, James Hogan <james.hogan@imgtec.com> wrote:
> >> On 06/02/13 13:11, Grant Likely wrote:
> >>> - Resources on platform_devices get registered so they appear in
> >>> /proc/iomem and /proc/ioports and so that device drivers get the added
> >>> protection of request_region. This will cause breakage on device trees
> >>> nodes with partially overlapping memory regions. (ie. 0x100..0x1ff and
> >>> 0x180..0x27f). I also have a workaround for this, but I doubt that it
> >>> will be necessary.
> >>
> >> Hi Grant,
> >>
> >> If I understand you correctly, the non-overlapping memory regions thing
> >> could be a problem for me. We have a Meta based SoC that has various SoC
> >> registers grouped together for doing GPIOs and Pin control things. I'm
> >> still in the process of converting it to device tree, but the way I've
> >> been handling it is to provide overlapping registers to both the gpio
> >> and pinctl DT nodes. Each GPIO bank's registers are also interleaved
> >> with the others, so I've been providing overlapping register ranges
> >> (offset by 4 for each bank) to the DT node for each gpio bank too, so
> >> each bank can function independently and the driver doesn't have to
> >> worry about multiple banks. Does that sound like a reasonable use case?
> >>
> >> I guess I could cheat with the length, or specify each register in it's
> >> own memory resource, but it seems like overkill.
> > 
> > Note that overlapping regions are fine /provided/ that they are the
> > same size or one fits nicely inside another. It's partial overlap that
> > is a problem
> 
> It still feels a bit artificial to impose that limitation on something
> that is supposed to be implementation independent. Having said that it
> doesn't particularly bother me having to work around it.

I've backed out on this. It broke too much.

g.

