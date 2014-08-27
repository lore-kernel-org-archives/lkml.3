Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935699AbaH0UGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:06:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaH0UGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:06:15 -0400
Date: Wed, 27 Aug 2014 13:06:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
Message-Id: <20140827130613.c8f6790093d279a447196f17@linux-foundation.org>
In-Reply-To: <cover.1409110741.git.matthew.r.wilcox@intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014 23:45:20 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> One of the primary uses for NV-DIMMs is to expose them as a block device
> and use a filesystem to store files on the NV-DIMM.  While that works,
> it currently wastes memory and CPU time buffering the files in the page
> cache.  We have support in ext2 for bypassing the page cache, but it
> has some races which are unfixable in the current design.  This series
> of patches rewrite the underlying support, and add support for direct
> access to ext4.

Sat down to read all this but I'm finding it rather unwieldy - it's
just a great blob of code.  Is there some overall
what-it-does-and-how-it-does-it roadmap?

Some explanation of why one would use ext4 instead of, say,
suitably-modified ramfs/tmpfs/rd/etc?

Performance testing results?

Carsten Otte wrote filemap_xip.c and may be a useful reviewer of this
work.

All the patch subjects violate Documentation/SubmittingPatches
section 15 ;)
