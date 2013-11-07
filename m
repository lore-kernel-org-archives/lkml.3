Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3KGTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:25:26 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47837 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3KGTZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:25:19 -0500
Date: Thu, 7 Nov 2013 11:25:45 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20131107192545.GA20624@moria.home.lan>
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>
 <5273C473.5070803@kernel.dk>
 <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au>
 <52740EB1.2070901@kernel.dk>
 <527411DD.7050008@oracle.com>
 <527414DE.9090704@kernel.dk>
 <52756583.2030808@oracle.com>
 <527BE7FA.90904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527BE7FA.90904@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 01:20:26PM -0600, Dave Kleikamp wrote:
> On 11/02/2013 03:50 PM, Dave Kleikamp wrote:
> > On 11/01/2013 03:53 PM, Jens Axboe wrote:
> 
> >> So we've three immediate options:
> >>
> >> 1) You base it on top of the block tree
> >> 2) I carry the loop updates
> >> 3) You hand Stephen a merge patch for the resulting merge of the two
> > 
> > Attached is a merge patch and the merged loop.c. I'm having problems
> > with the loop driver with both the block and my tree. I'll continue to
> > look at that, but everything should build cleanly with this.
> 
> Looking back, I obviously rushed the last patch out. This merge patch,
> and the resulting loop.c, fix my problem. My code is working with Jens'
> block tree now.
> 
> Jens,
> I ended up replacing a call to bio_iovec_idx() with __bvec_iter_bvec()
> since the former was removed. It's not very elegant, but it works. I'm
> open to suggestions on a cleaner fix, but it can wait until one or both
> of these trees is merged.

No, that's definitely wrong. Read Documentation/block/biovecs.txt - you
need to use either the new bio_iovec() or bio_iovec() iter. I can do the
conversion later today.
