Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab3ANV7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:59:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab3ANV7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:59:32 -0500
Date: Mon, 14 Jan 2013 22:59:30 +0100
From: Jan Kara <jack@suse.cz>
To: James Hogan <james@albanarts.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL pointer dereference in udf_sb_free_partitions
Message-ID: <20130114215930.GA30482@quack.suse.cz>
References: <20130112220015.GA2387@balrog>
 <CAKYAXd_zYTfaCw445Cc2uCbry=w9nLKBgivOc2M5chK7o_rE=Q@mail.gmail.com>
 <20130114210637.GA2122@balrog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114210637.GA2122@balrog>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-01-13 21:06:37, James Hogan wrote:
> Hi,
> 
> On Mon, Jan 14, 2013 at 02:19:39PM +0900, Namjae Jeon wrote:
> > There is missing exception handling in memory leak patch. (udf: Fix
> > memory leak when mounting)
> > So, Would you try to reproduce this problem with the below patch ?
> > 
> > Thanks.
> > 
> > ---------------------------------------------------------------------------
> > Subject: [PATCH] UDF: Fix a null pointer dereference in udf_sb_free_partitions
> > 
> > This patch fixes a regression caused by commit bff943af6fe
> > "udf: Fix memory leak when mounting" due to which it was triggering
> > a kernel null point dereference in case of mount failed OR when allocating
> > memory to sbi->s_partmaps failed in function udf_sb_alloc_partition_maps.
> > 
> > Reported-by: James Hogan <james@albanarts.com>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> 
> v3.8-rc3 + your patch no longer crashes.
> 
> Tested-by: James Hogan <james@albanarts.com>
  Thanks for confirmation. I've added the fix to my tree and will push it
to Linus soon.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
