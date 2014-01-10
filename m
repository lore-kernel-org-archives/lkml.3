Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaAJJ3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:29:33 -0500
Received: from verein.lst.de ([213.95.11.211]:38449 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbaAJJ3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:29:31 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2014 04:29:30 EST
Date: Fri, 10 Jan 2014 10:22:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Richard Weinberger <richard@nod.at>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@lst.de,
        eric.dumazet@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/inode: No need to take ->i_lock right after
	alloc_inode()
Message-ID: <20140110092229.GA556@lst.de>
References: <1387054495-31498-1-git-send-email-richard@nod.at> <1524545.iNFYXWHlaf@sandpuppy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524545.iNFYXWHlaf@sandpuppy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:21:13AM +0100, Richard Weinberger wrote:
> > In all three cases, new_inode_pseudo(), iget_locked() and iget5_locked(),
> > we own the new inode exclusively at this point and therefore taking
> > ->i_lock to protect ->i_state/->i_hash against concurrent access is
> > superfluous.

We'd still need some sort of barrier to make sure the state is visible
to all CPUs before it becomes visible, usually by another spin_unlock
happing later.  If you have a workload where removing these is critical
please document these issues in the code and resubmit it with an explanation
of the workload where it helps.  If it's just a cleanup I wouldn't bother
with it.

