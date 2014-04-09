Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985AbaDIUwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:52:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:9252 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590AbaDIUwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:52:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,828,1389772800"; 
   d="scan'208";a="510390472"
Date: Wed, 9 Apr 2014 16:51:11 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140409205111.GG5727@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409102758.GM32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409102758.GM32103@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 12:27:58PM +0200, Jan Kara wrote:
> > +	if (unlikely(vmf->pgoff >= size)) {
> > +		mutex_unlock(&mapping->i_mmap_mutex);
> > +		goto sigbus;
>   You need to release the block you've got from the filesystem in case of
> error here an below.

What's the API to do that?  Call inode->i_op->setattr()?
