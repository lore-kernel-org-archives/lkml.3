Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3BDMrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:47:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab3BDMrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:47:17 -0500
Date: Mon, 4 Feb 2013 13:47:15 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] fs: Take mapping lock in generic read paths
Message-ID: <20130204124715.GF7523@quack.suse.cz>
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
 <1359668994-13433-3-git-send-email-jack@suse.cz>
 <20130131155940.7b1f8e0e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131155940.7b1f8e0e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31-01-13 15:59:40, Andrew Morton wrote:
> On Thu, 31 Jan 2013 22:49:50 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > Add mapping lock to struct address_space and grab it in all paths
> > creating pages in page cache to read data into them. That means buffered
> > read, readahead, and page fault code.
> 
> Boy, this does look expensive in both speed and space.
  I'm not sure I'll be able to do much with the space cost but hopefully
the CPU cost could be reduced.

> As you pointed out in [0/n], it's 2-3%.  As always with pagecache
> stuff, the cost of filling the page generally swamps any inefficiencies
> in preparing that page.
  Yes, I measured it with with ramdisk backed fs exactly to remove the cost
of filling the page from the picture. But there are systems where IO is CPU
bound (e.g. when you have PCIe attached devices) and although there is the
additional cost of block layer which will further hide the cost of page
cache itself I assume the added 2-3% incurred by page cache itself will be
measurable on such systems. So that's why I'd like to reduce the CPU cost
of range locking.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
