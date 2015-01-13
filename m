Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbbAMJkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:40:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbAMJkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:40:45 -0500
Date: Tue, 13 Jan 2015 11:40:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 22/40] tile: fix put_user sparse errors
Message-ID: <20150113094032.GA6526@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-23-git-send-email-mst@redhat.com>
 <54B44326.6010501@ezchip.com>
 <20150113093535.GA4434@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113093535.GA4434@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:35:35AM +0200, Michael S. Tsirkin wrote:
> On Mon, Jan 12, 2015 at 04:56:54PM -0500, Chris Metcalf wrote:
> > Nack for this patch as-is.
> > 
> > On 1/6/2015 10:44 AM, Michael S. Tsirkin wrote:
> > >virtio wants to write bitwise types to userspace using put_user.
> > >At the moment this triggers sparse errors, since the value is passed
> > >through an integer.
> > >
> > >For example:
> > >
> > >	__le32 __user *p;
> > >	__le32 x;
> > >	put_user(x, p);
> > >
> > >is safe, but currently triggers a sparse warning on tile.
> > >
> > >The reason has to do with this code:
> > >	__typeof((x)-(x))
> > >which seems to be a way to force check for an integer type.
> > 
> > No, it's purely a way to avoid
> > 
> >   warning: cast from pointer to integer of different size
> > 
> > at every place we invoke put_user() with a pointer - which is
> > in fact pretty frequent throughout the kernel.
> >
> >  The idiom of
> > casting to the difference of the type converts it to a type
> > of the same size as the input (whether integral or pointer),
> > but guaranteed to be an integral type.  Then from there it's safe
> > to cast it on to a u64 without generating a warning.
> 
> Thanks for the comments.  OK, I see, though I wonder why didn't
> kbuild notify me about new warnings. Doesn't it build tile?
> 
> So if you want to merge your patch, please let me know.
> 
> But I think the fix can be much simpler: unsigned long has the same property
> without any of the complexity, or problems with sparse.  So how about this:


Oh, I see you have written a better patch already.
Please ignore mine.
