Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaJMFmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:42:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaJMFmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:42:19 -0400
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 13 Oct 2014 16:41:28 +1100
Subject: [PATCH 0/2 V3] Allow access to sysfs attributes without mem
 allocations.
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20141013053733.19481.43981.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
 please consider these two patches for a future release.
 They now have
   Reviewed-by: Tejun Heo <tj@kernel.org>
 and I've addressed Tejun's final nits.

 Thanks Tejun for your review and comments.

 As soon as they appear in an -rc1, I'll submit updates to md to use
 the new functionality for the -rc2.

Thanks,
NeilBrown


---

NeilBrown (2):
      sysfs/kernfs: allow attributes to request write buffer be pre-allocated.
      sysfs/kernfs: make read requests on pre-alloc files use the buffer.


 fs/kernfs/file.c       |   73 +++++++++++++++++++++++++++++++++---------------
 fs/sysfs/file.c        |   57 ++++++++++++++++++++++++++++++++-----
 include/linux/kernfs.h |    8 +++++
 include/linux/sysfs.h  |    9 ++++++
 4 files changed, 116 insertions(+), 31 deletions(-)

-- 
Signature

