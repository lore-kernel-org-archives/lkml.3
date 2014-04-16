Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaDPGbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:31:33 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47901 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbaDPGbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:31:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AslSALMiTlN5LEcvPGdsb2JhbABYgwaDU4UKtgyFXoEcFwMBAQEBODWCJQEBAQQ6HCMQCAMYCSUPBSUDBxoTh3vFYRcWjkwHhDgBA5hiimeJUoFRKw
Date: Wed, 16 Apr 2014 16:31:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 09/19] XFS: ensure xfs_file_*_read cannot deadlock in
 memory allocation.
Message-ID: <20140416063129.GI15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
 <20140416040336.10604.90380.stgit@notabene.brown>
 <20140416060459.GE15995@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416060459.GE15995@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 04:04:59PM +1000, Dave Chinner wrote:
> On Wed, Apr 16, 2014 at 02:03:36PM +1000, NeilBrown wrote:
> > xfs_file_*_read holds an inode lock while calling a generic 'read'
> > function.  These functions perform read-ahead and are quite likely to
> > allocate memory.
> 
> Yes, that's what reading data from disk requires.
> 
> > So set PF_FSTRANS to ensure they avoid __GFP_FS and so don't recurse
> > into a filesystem to free memory.
> 
> We already have that protection via the

Oops, stray paste. Ignore that comment.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
