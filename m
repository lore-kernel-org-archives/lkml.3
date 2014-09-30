Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaI3Ot5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:49:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:44054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaI3Oty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,626,1406617200"; 
   d="scan'208";a="610929837"
Date: Tue, 30 Sep 2014 10:48:54 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
Message-ID: <20140930144854.GA5098@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <15705.1412070301@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15705.1412070301@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 05:45:01AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 25 Sep 2014 16:33:17 -0400, Matthew Wilcox said:
> 
> > Patch 19 adds some DAX infrastructure to support ext4.
> >
> > Patch 20 adds DAX support to ext4.  It is broadly similar to ext2's DAX
> > support, but it is more efficient than ext4's due to its support for
> > unwritten extents.
> 
> I don't currently have a use case for NV-DIMM support.
> 
> However, it would be nice if this code could be leveraged to support
> 'force O_DIRECT on all I/O to this file' - that I *do* have a use
> case for.  Patch 20 looks to my untrained eye like it *almost* gets
> there.
> 
> (And if in fact it *does* do the whole enchilada, the Changelog etc should
> mention it :)

No, it doesn't try to do that.  Wouldn't you be better served with an
LD_PRELOAD that forces O_DIRECT on?

