Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaJQHEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:04:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:52344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbaJQHCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401670930"
Date: Thu, 16 Oct 2014 17:52:56 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 16/21] vfs,ext2: Remove CONFIG_EXT2_FS_XIP and rename
 CONFIG_FS_XIP to CONFIG_FS_DAX
Message-ID: <20141016215256.GJ11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-17-git-send-email-matthew.r.wilcox@intel.com>
 <20141016122618.GN19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016122618.GN19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:26:18PM +0200, Mathieu Desnoyers wrote:
> > +	bool "Direct Access support"
> > +	depends on MMU
> > +	help
> > +	  Direct Access (DAX) can be used on memory-backed block devices.
> > +	  If the block device supports DAX and the filesystem supports DAX,
> > +	  then you can avoid using the pagecache to buffer I/Os.  Turning
> > +	  on this option will compile in support for DAX; you will need to
> > +	  mount the filesystem using the -o xip option.
> 
> There is a mismatch between the documentation file (earlier patch): -o
> dax, and this config description: -o xip.

Whoops!  Good catch.

> I guess we might want to switch the mount option to "-o dax" and
> document it as such, and since it should be usable transparently for the
> same use-cases "-o xip" was enabling, we might want to keep parsing of
> "-o xip" in the code for backward compatibility.
> 
> Thoughts ?

That's exactly what we do for ext2.  For ext4, we force people to use
the new -o dax option.  We stop documenting that -o xip exist, and we
print a message to tell people to switch over to -o dax.

