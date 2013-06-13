Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab3FMSdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:33:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37604 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab3FMSdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:33:20 -0400
Date: Thu, 13 Jun 2013 11:33:15 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bio-integrity: Fix use of bs->bio_integrity_pool after
 free
Message-ID: <20130613183315.GH10979@localhost>
References: <20130529222955.10627.50429.stgit@bhelgaas-glaptop>
 <CAErSpo7s1m=6WvgeVOQ3Zj=mU8=+13pT4hJ8k5-KkrDDGOU+5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7s1m=6WvgeVOQ3Zj=mU8=+13pT4hJ8k5-KkrDDGOU+5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 12:14:54PM -0600, Bjorn Helgaas wrote:
> On Wed, May 29, 2013 at 4:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > This fixes a copy and paste error introduced by 9f060e2231
> > ("block: Convert integrity to bvec_alloc_bs()").
> >
> > Found by Coverity (CID 1020654).
> >
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > ---
> >  fs/bio-integrity.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> > index 8fb4291..45e944f 100644
> > --- a/fs/bio-integrity.c
> > +++ b/fs/bio-integrity.c
> > @@ -734,7 +734,7 @@ void bioset_integrity_free(struct bio_set *bs)
> >                 mempool_destroy(bs->bio_integrity_pool);
> >
> >         if (bs->bvec_integrity_pool)
> > -               mempool_destroy(bs->bio_integrity_pool);
> > +               mempool_destroy(bs->bvec_integrity_pool);
> >  }
> >  EXPORT_SYMBOL(bioset_integrity_free);
> 
> Kent, do you want to chime in on this?  Looks like an obvious error to
> me, but maybe I'm missing something and we should teach Coverity to
> shut up about it.

Sorry - no, this is definitely a bug:

Acked-by: Kent Overstreet <koverstreet@google.com>
