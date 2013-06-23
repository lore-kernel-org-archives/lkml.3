Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3FWWLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 18:11:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab3FWWK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 18:10:58 -0400
Date: Mon, 24 Jun 2013 00:10:55 +0200
From: Michal Marek <mmarek@suse.cz>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        nico-linuxsetlocalversion@schottelius.org
Subject: Re: [PATCH] scripts/setlocalversion on write-protected source tree
Message-ID: <20130623221055.GA16118@pobox.suse.cz>
References: <alpine.DEB.2.10.1306141756510.13746@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306141756510.13746@trent.utfs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 06:04:34PM -0700, Christian Kujau wrote:
> I just stumbled across another[0] issue when scripts/setlocalversion 
> operates on a write-protected source tree. Back then[0] the source tree 
> was on an read-only NFS share, so "test -w" was introduced before "git 
> update-index" was run.
> 
> This time, the source tree is on read/write NFS share, but the permissions 
> are world-readable and only a specific user (or root) can write. 
> Thus, "test -w ." returns "0" and then runs "git update-index", 
> producing the following message (on a dirty tree):
> 
>   fatal: Unable to create '/usr/local/src/linux-git/.git/index.lock': Permission denied
> 
> While it says "fatal", compilation continues just fine.
> 
> However, I don't think a kernel compilation should alter the source 
> tree (or the .git directory) in any way and I don't see how removing 
> "git update-index" could do any harm. The Mercurial and SVN routines in 
> scripts/setlocalversion don't have any tree-modifying commands, AFAICS. 
> So, maybe the patch below would be acceptable.

Applied to kbuild.git#kbuild.

Thanks,
Michal
