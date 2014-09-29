Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaI2Sng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:43:36 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:55392 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaI2Snf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:43:35 -0400
Date: Mon, 29 Sep 2014 22:43:33 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND v3 PATCH 3/3] vfs: make mounts and mountstats honor root dir like mountinfo does
Message-ID: <20140929184333.GD15829@altlinux.org>
References: <20140929180523.GC15829@altlinux.org> <20140929183222.GJ7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929183222.GJ7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 07:32:22PM +0100, Al Viro wrote:
> On Mon, Sep 29, 2014 at 10:05:23PM +0400, Dmitry V. Levin wrote:
> > Date: Wed, 17 Oct 2012 20:29:55 +0400
> > 
> > Change show_vfsmnt() and show_vfsstat() to show mountpoints relative
> > to the root directory and skip mountpoints outside of chroot jail
> > the same way as show_mountinfo() does.
> 
> Sigh...  Repeat after me:  We  Do  Not  Break  Userland.  Care to explain
> why that change won't do just that?

This is definitely an information leak, and I cannot imagine how these
unaccessible entries listed in /proc/self/mounts and /proc/self/mountstats
could be used sanely.


-- 
ldv
