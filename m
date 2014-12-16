Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaLPNdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:33:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47419 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaLPNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:33:32 -0500
Date: Tue, 16 Dec 2014 13:33:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git pile 2
Message-ID: <20141216133330.GB22149@ZenIV.linux.org.uk>
References: <20141215235124.GX22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215235124.GX22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:51:25PM +0000, Al Viro wrote:
> Next pile (and there'll be one or two more).  The large piece in this one is
> getting rid of /proc/*/ns/* weirdness; among other things, it allows to
> (finally) make nameidata completely opaque outside of fs/namei.c, making for
> easier further cleanups in there.
> 
> I have _not_ included removal of unshare_fs_struct() into that pile; I think
> it'll turn out to be OK, but it's clearly the next cycle fodder.

... but I have included the "obviously safe" patch separating PID 1
->fs.  Without letting it sit in -next long enough.  And it turns out
to be not safe at all - it might be salvagable, but not in this form.

Mea maxima culpa - I should've known better than that.  Self-LART applied;
please, drop this pull request, I'll send a saner one (for stuff that *did*
sit in -next long enough) in a bit.

Again, my apologies ;-/
