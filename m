Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3CRURP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:17:15 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36878 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3CRURN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:17:13 -0400
Date: Mon, 18 Mar 2013 13:18:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: stable <stable@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Revert a bunch of patches in stable kernels
Message-ID: <20130318201828.GB11643@kroah.com>
References: <CAKMK7uE9o7CT4Bn1SrPyCa+bGrHmj2-+cpDYP__gUU+BRiGH7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uE9o7CT4Bn1SrPyCa+bGrHmj2-+cpDYP__gUU+BRiGH7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:05:26AM +0100, Daniel Vetter wrote:
> Hi Greg&all,
> 
> So a recent stable backport to fix rc6 on ilk (which is disabled by
> default and with dubious power savings at best, unlike rc6 on snb and
> later) totally blew up all over the place:
> https://bugzilla.kernel.org/show_bug.cgi?id=55291
> https://lkml.org/lkml/2013/3/14/540
> 
> There might be more, I'm still recovering from mail floods due to
> traveling last week. I think the right course of action is to revert
> the offending patch (plus anything depending upon it) and give up on
> rc6 on ilk in 3.8 - too messy. All bug reports confirmed that 3.9-rc
> kernels work as expected. Upstream commits to revert:
> 
> 15239099d7a7a9ecdc1ccb5b187ae4cda5488ff9 drm/i915: enable irqs earlier
> when resuming
> 52d7ecedac3f96fb562cb482c139015372728638 drm/i915: reorder setup
> sequence to have irqs for output setup

Thanks for tracking this down, I've reverted both of these patches now,
which should hopefully fix the issues reported.

greg k-h
