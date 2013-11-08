Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3KHCIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:08:14 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46879 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3KHCII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:08:08 -0500
Date: Thu, 7 Nov 2013 18:08:05 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20131108020805.GI3842@kmo>
References: <5273C473.5070803@kernel.dk>
 <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au>
 <52740EB1.2070901@kernel.dk>
 <527411DD.7050008@oracle.com>
 <527414DE.9090704@kernel.dk>
 <52756583.2030808@oracle.com>
 <527BE7FA.90904@oracle.com>
 <20131107192545.GA20624@moria.home.lan>
 <527C2AA9.9040608@oracle.com>
 <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:53:07PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Thu, 07 Nov 2013 18:04:57 -0600 Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
> >
> > Can you please drop the aio-direct tree for the time being?
> 
> OK, I was afraid of this, but, yes, I can drop it.  I am not quite sure
> what affect this will have on Andrew's tree, though (hopefully not too
> much).
> 
> This is a bit disappointing.  Dave's stuff have been sitting in
> linux-next for quite some time (probably too long) so it is not as if
> Kent and Jens (should) have been unaware of it.

Yeah, I have to apologize for not noticing sooner. Mea culpa. That said, we
spent some time hashing things out on IRC and I'm pretty excited for the new
plan; Zach Brown also had some good input.

> > My stuff is not aligning very well with the immutable biovecs and Kent
> > has a different approach in mind. I'll be working with him on a
> > replacement that will hopefully be simpler.
> 
> Presumably not before v3.14, right?

Yeah, the gist of it is that loopback driver is going to be passing bios
directly to the dio code - my dio rewrite gets us most of the way there, and
after immutable biovecs there's only ~3 (much simpler) patches left that the dio
rewrite depends on.

The remaining issue to deal with is the fact that on writes, the dio code bails
out if it hits an unmapped block (i.e. a hole) and filemap.c finishes it up with
the buffered io code - we need the dio code to handle that in a self contained
fashion. Zach had a (horribly ugly, but definitely workable) idea for that, so
I'm feeling pretty optimistic about this right now.
