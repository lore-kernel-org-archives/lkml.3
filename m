Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaI2W4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:56:37 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:46503 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaI2W4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:56:35 -0400
Date: Tue, 30 Sep 2014 02:56:33 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND v3 PATCH 3/3] vfs: make mounts and mountstats honor root dir like mountinfo does
Message-ID: <20140929225633.GA16855@altlinux.org>
References: <20140929180523.GC15829@altlinux.org> <20140929183222.GJ7996@ZenIV.linux.org.uk> <20140929184333.GD15829@altlinux.org> <20140929193329.GL7996@ZenIV.linux.org.uk> <20140929202659.GA16292@altlinux.org> <20140929212057.GN7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929212057.GN7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:20:57PM +0100, Al Viro wrote:
> On Tue, Sep 30, 2014 at 12:26:59AM +0400, Dmitry V. Levin wrote:
> 
> > > Again, we do not break userland.
> > 
> > Occasionally, we do.  If you say there was no chroot prefix removal in the
> > kernel before, and there seems to be a prefix removal for at least 5 years,
> > then there must have been a break some years ago that went unnoticed.
> 
> D'oh!  Yes, we did.  And yes, it was quite a few years ago, actually - back
> in 2000.  I plead being low on sleep and lower on caffeine...
> 
> For a moment I was even afraid that it was my own doing, but no - it came
> in https://lkml.org/lkml/2000/1/16/54.  Werner Almesberger.  IIRC, I hadn't
> realized that it was going to cause fun problems back then - basically,
> by that point 2.3 and 2.2 had already diverged a lot and quite a few things
> got written off as "oh, well - upgrade from 2.2 to 2.4 is going to be not
> far from building the system from scratch anyway, and nobody sane would be
> using 2.3 on anything other than scratch filesystem - IDE broken more often
> than not, memory corruption aplenty, etc."

Thanks, I won't be able to locate the change that fast.

It also means that the phrase "show mountpoints relative to the root
directory" I used in the commit message is irrelevant and should be
removed to avoid confusion.

> My apologies.  Hmm...  Filtering the out-of-root ones out is probably OK,
> but let's put that into -next after 3.18-rc1 and see if anyone yells.

BTW, the cleanup patch (vfs: cleanup show_mountinfo) could be safely
applied anytime - it's completely harmless.


-- 
ldv
