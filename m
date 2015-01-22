Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbbAVHyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:54:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48828 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbAVHyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:54:31 -0500
Date: Thu, 22 Jan 2015 07:54:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Moore <pmoore@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, rgb@redhat.com, sd@queasysnail.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
Message-ID: <20150122075429.GV29656@ZenIV.linux.org.uk>
References: <20150122045303.1347.98054.stgit@localhost>
 <54C08C62.8010609@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C08C62.8010609@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:36:34PM -0800, Guenter Roeck wrote:
> On 01/21/2015 08:59 PM, Paul Moore wrote:
> >This patchset has some important changes from the previous revision,
> >namely a fix from Al Viro (included in 2/5) that resolves a boot panic
> >on some systems as well as some smaller, less noteworthy fixes found
> >in the linux-next announcement thread from January 20th (refcount bump
> >in __audit_reusename() and a inode type in __audit_inode()).
> >
> >This patchset still needs some additional testing to verify that the
> >audit code still functions properly (the minor fixes mentioned above)
> >and there is an additional patch from Al that should be included as
> >well, but I wanted to post this and push the series to the audit next
> >branch quickly since a number of folks were affected by the boot panic.
> >
> >---
> >
> >Paul Moore (5):
> >       fs: rework getname_kernel to handle up to PATH_MAX sized filenames
> >       fs: create proper filename objects using getname_kernel()
> >       audit: enable filename recording via getname_kernel()
> >       audit: fix filename matching in __audit_inode() and __audit_inode_child()
> >       audit: replace getname()/putname() hacks with reference counters
> >
> Hi Paul,
> 
> What is the baseline for this patch set ? Obviously -next won't work,
> and it does not apply to mainline either.

FWIW, I've ported that on top of vfs.git#for-next; result is in
vfs.git#experimental.  Paul, are you OK with that one?
