Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaAJJtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:49:10 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753916AbaAJJtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:49:05 -0500
From: Richard Weinberger <richard@nod.at>
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, eric.dumazet@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/inode: No need to take ->i_lock right after alloc_inode()
Date: Fri, 10 Jan 2014 10:48:57 +0100
Message-ID: <14058048.nDrCfeHD0z@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140110092229.GA556@lst.de>
References: <1387054495-31498-1-git-send-email-richard@nod.at> <1524545.iNFYXWHlaf@sandpuppy> <20140110092229.GA556@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Januar 2014, 10:22:29 schrieb Christoph Hellwig:
> On Wed, Jan 08, 2014 at 11:21:13AM +0100, Richard Weinberger wrote:
> > > In all three cases, new_inode_pseudo(), iget_locked() and
> > > iget5_locked(),
> > > we own the new inode exclusively at this point and therefore taking
> > > ->i_lock to protect ->i_state/->i_hash against concurrent access is
> > > superfluous.
> 
> We'd still need some sort of barrier to make sure the state is visible
> to all CPUs before it becomes visible, usually by another spin_unlock
> happing later.  If you have a workload where removing these is critical
> please document these issues in the code and resubmit it with an explanation
> of the workload where it helps.  If it's just a cleanup I wouldn't bother
> with it.

The patch was indented as cleanup patch, but as you pointed out I've failed to
think about the barrier.
Let's drop the patch. :D

Thanks,
//richard
