Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaI2VVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:21:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53703 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaI2VU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:20:58 -0400
Date: Mon, 29 Sep 2014 22:20:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND v3 PATCH 3/3] vfs: make mounts and mountstats honor root
 dir like mountinfo does
Message-ID: <20140929212057.GN7996@ZenIV.linux.org.uk>
References: <20140929180523.GC15829@altlinux.org>
 <20140929183222.GJ7996@ZenIV.linux.org.uk>
 <20140929184333.GD15829@altlinux.org>
 <20140929193329.GL7996@ZenIV.linux.org.uk>
 <20140929202659.GA16292@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929202659.GA16292@altlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:26:59AM +0400, Dmitry V. Levin wrote:

> > Again, we do not break userland.
> 
> Occasionally, we do.  If you say there was no chroot prefix removal in the
> kernel before, and there seems to be a prefix removal for at least 5 years,
> then there must have been a break some years ago that went unnoticed.

D'oh!  Yes, we did.  And yes, it was quite a few years ago, actually - back
in 2000.  I plead being low on sleep and lower on caffeine...

For a moment I was even afraid that it was my own doing, but no - it came
in https://lkml.org/lkml/2000/1/16/54.  Werner Almesberger.  IIRC, I hadn't
realized that it was going to cause fun problems back then - basically,
by that point 2.3 and 2.2 had already diverged a lot and quite a few things
got written off as "oh, well - upgrade from 2.2 to 2.4 is going to be not
far from building the system from scratch anyway, and nobody sane would be
using 2.3 on anything other than scratch filesystem - IDE broken more often
than not, memory corruption aplenty, etc."

My apologies.  Hmm...  Filtering the out-of-root ones out is probably OK,
but let's put that into -next after 3.18-rc1 and see if anyone yells.
