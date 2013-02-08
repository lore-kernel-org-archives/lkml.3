Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab3BHWCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:02:20 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53158 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab3BHWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:02:18 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] platform: Fix platform device resource linking
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <82FE4A4D-DCA8-4C2C-97E7-6B73D424DCF5@antoniou-consulting.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com> <20130103224020.GB4571@kroah.com> <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com> <20130117163159.GD1396@kroah.com> <95056678-DF1A-4C49-BEAE-C5EBD7E56405@antoniou-consulting.com> <20130117170719.GB9163@kroah.com> <87DCB3B7-0A5A-42F0-BF9C-0E91B56960C6@antoniou-consulting.com> <20130118030017.GA11423@kroah.com> <82FE4A4D-DCA8-4C2C-97E7-6B73D424DCF5@antoniou-consulting.com>
Date: Fri, 08 Feb 2013 22:02:13 +0000
Message-Id: <20130208220213.4525A3E2C27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 11:05:14 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> Hi Greg,
> 
> On Jan 18, 2013, at 5:00 AM, Greg Kroah-Hartman wrote:
> 
> > On Thu, Jan 17, 2013 at 07:27:21PM +0200, Pantelis Antoniou wrote:
> >>>> In a nutshell, we have to exercise the platform device subsystem, in ways
> >>>> that never happened before, so all sorts of weird bugs that no-one has seen
> >>>> before.
> >>> 
> >>> Why do you have to do this?  What are you doing that is so different
> >>> from everyone else?  What drivers are you using that trigger this type
> >>> of thing?
> >>> 
> >> 
> >> This is all part of a larger patchset; I guess you weren't directly CCed.
> >> The name of the patchset is 'Introducing Device Tree Overlays' and is a
> >> method of changing the live device tree and have the changes reflected to
> >> the kernel's state.
> > 
> > Ok, no wonder I was confused :)
> > 
> > How about cc:ing me on the next round of these patches, all of the,
> > which will give me the proper background as to what is going on?
> > 
> 
> Will do. I'm still waiting for some feedback from the DT maintainers, but
> I will make sure that you will be CCed on the next revision.
> 
> You can of course take a look at it and comment on the current version too. 
>   
> >>>> In that case, the code path for creating platform devices from DT is
> >>>> not the same as the one that is used when creating platform device from
> >>>> a board file.
> >>> 
> >>> Why not?
> >>> 
> >> 
> >> Because while DT creates platform devices, it doesn't use the platform device
> >> methods to do so, rather than builds the platform device itself. This is 
> >> something that was overlooked.
> > 
> > Can't this be fixed?  What does the platform device core need to do to
> > resolve this?
> > 
> 
> Hmm, due to historical reasons the two ways of creating platform devices
> have diverged. The core of the issue is that while OF creates platform devices
> it does so in it's own way.

It's actually the other way around. The DT code path used to be a
completely separate of_platform_bus_type that didn't share any code with
platform_bus_type. So in fact, the code patches have converged instead
of diverged.

When I merged the paths there were some breakages that prevented me from
using platform_device_add() directly. Most of those are now gone and

I've got a patch in my tree which makes the OF code use
platform_device_add(). That makes this patch series unnecessary. The
patch is currently in linux-next. Assuming I don't run into any major
problems it will be merged in v3.9

> The problem with doing anything like this would be that a whole bunch of
> devices/arches depend on DT, and if anything breaks there will be a lot of
> angry people with pitchforks after the culprit.

Pitchforks? pish. It's the torches that are dangerous.

g.
