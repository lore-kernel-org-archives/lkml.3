Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaE1GBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:01:17 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8866 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbaE1GBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:01:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmxSADN7hVN5LL1sPGdsb2JhbABZgweDRIUIongBAQEBAQEGmA0BgQkXAwEBAQE4NYIlAQEFOhwjEAgDGAklDwUlAwcaE4hB1VgXFoU/iH0HhEAEmXOWcis
Date: Wed, 28 May 2014 16:00:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: xfs@oss.sgi.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: xfs: possible deadlock warning
Message-ID: <20140528060050.GK8554@dastard>
References: <538571D4.70904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538571D4.70904@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 01:19:16PM +0800, Gu Zheng wrote:
> Hi all,
> When running the latest Linus' tree, the following possible deadlock warning occurs.

false positive. There isn't a deadlock between inode locks on
different filesystems. i.e. there is no dependency between shmem
inodes and xfs inodes, nor on their security contexts.  Nor can you
take a page fault on a directory inode, which is the XFS inode lock
class it's complaining about.

Fundamentally, the problem here is shmem instantiating a new inode
with the mmap_sem held. That's just plain wrong...


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
