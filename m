Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbbALVDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:03:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbbALVDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:03:21 -0500
From: Paul Moore <pmoore@redhat.com>
To: linux-audit@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Overhaul the audit filename handling
Date: Mon, 12 Jan 2015 16:03:18 -0500
Message-ID: <2809190.iPDDC9gGz8@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150108164514.11316.85331.stgit@localhost>
References: <20150108164514.11316.85331.stgit@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 11:50:23 AM Paul Moore wrote:
> There have been some patches added to v3.19-rcX to fix various
> problems in the way audit handles filenames but they have been hacks
> on top of hacks, not really something we want long term.  This
> patchset reworks the way audit handles filenames, removing a lot of
> nasty hacks added recently, and fixing a few bugs that still remain.
> 
> Most significant to folks outside of audit, patch 5/5 does away with
> the nasty getname()/putname() kludge in favor of a less ugly reference
> count approach.
> 
> Comments and feedback are welcome.  If nothing ugly pops up on review
> I'll see if Linus is interested in taking this for the next v3.19-rcX
> release, otherwise I'll toss it into linux-next for v3.20.
> 
> -Paul
> 
> ---
> 
> Paul Moore (5):
>       fs: rework getname_kernel to handle up to PATH_MAX sized filenames
>       fs: create proper filename objects using getname_kernel()
>       audit: enable filename recording via getname_kernel()
>       audit: fix filename matching in __audit_inode() and
>              __audit_inode_child()
>       audit: replace getname()/putname() hacks with reference counters
> 
> 
>  fs/exec.c             |   11 +++
>  fs/namei.c            |   98 ++++++++++++++++++-----------
>  fs/open.c             |   11 +++
>  include/linux/audit.h |    3 -
>  include/linux/fs.h    |    9 +--
>  kernel/audit.h        |   17 +----
>  kernel/auditsc.c      |  167 ++++++++-------------------------------------
>  7 files changed, 115 insertions(+), 201 deletions(-)

Al/fs dev: any chance you guys can take a quick look at the fs relevant 
portions of this patchset and give it a ACK/NACK?  I'll carry the patchset in 
the audit tree, but I'd like to see a thumbs up from someone in fs land before 
I merge these patches.

Thanks,
-Paul

-- 
paul moore
security @ redhat

