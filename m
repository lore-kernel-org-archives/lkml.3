Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab3FMDSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:18:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:7241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab3FMDSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:18:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,855,1363158000"; 
   d="scan'208";a="349064097"
Date: Thu, 13 Jun 2013 11:18:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Zach Brown <zab@redhat.com>
Cc: Josef Bacik <jbacik@fusionio.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [josef-btrfs:master 61/69] fs/btrfs/delayed-inode.c:393:1:
 warning: control reaches end of non-void function
Message-ID: <20130613031830.GC11199@localhost>
References: <51b8c057.Wb46meK/SKAvZppd%fengguang.wu@intel.com>
 <20130612193211.GB8389@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612193211.GB8389@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 12:32:11PM -0700, Zach Brown wrote:
> >    fs/btrfs/delayed-inode.c: In function 'get_ins_del_root':
> > >> fs/btrfs/delayed-inode.c:393:1: warning: control reaches end of non-void function [-Wreturn-type]
> > 
> > vim +393 fs/btrfs/delayed-inode.c
> > 
> >    385	static struct rb_root *get_ins_del_root(struct btrfs_delayed_node *delayed_node,
> >    386						int ins_del)
> >    387	{
> >    388		if (ins_del == BTRFS_DELAYED_INSERTION_ITEM)
> >    389			return &delayed_node->ins_root;
> >    390		if (ins_del == BTRFS_DELAYED_DELETION_ITEM)
> >    391			return &delayed_node->del_root;
> >    392		BUG();
> >  > 393	}
> 
> Hrmph.
> 
> Is this false positive worth working around?  What version of gcc is
> this from?

gcc (Debian 4.7.1-6) 4.7.1

> I'd expect the unreachable() in BUG() to silence this
> warning on modern gcc.

Yeah it's strange why gcc still complain about that. Anyway I'll
detect and ignore this kind of false positive in my report scripts.

Thanks,
Fengguang
