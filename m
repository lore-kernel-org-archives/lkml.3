Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3FMSPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:15:17 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44547 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FMSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130529222955.10627.50429.stgit@bhelgaas-glaptop>
References: <20130529222955.10627.50429.stgit@bhelgaas-glaptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 13 Jun 2013 12:14:54 -0600
Message-ID: <CAErSpo7s1m=6WvgeVOQ3Zj=mU8=+13pT4hJ8k5-KkrDDGOU+5w@mail.gmail.com>
Subject: Re: [PATCH] bio-integrity: Fix use of bs->bio_integrity_pool after free
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 4:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> This fixes a copy and paste error introduced by 9f060e2231
> ("block: Convert integrity to bvec_alloc_bs()").
>
> Found by Coverity (CID 1020654).
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  fs/bio-integrity.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index 8fb4291..45e944f 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -734,7 +734,7 @@ void bioset_integrity_free(struct bio_set *bs)
>                 mempool_destroy(bs->bio_integrity_pool);
>
>         if (bs->bvec_integrity_pool)
> -               mempool_destroy(bs->bio_integrity_pool);
> +               mempool_destroy(bs->bvec_integrity_pool);
>  }
>  EXPORT_SYMBOL(bioset_integrity_free);

Kent, do you want to chime in on this?  Looks like an obvious error to
me, but maybe I'm missing something and we should teach Coverity to
shut up about it.

Bjorn
