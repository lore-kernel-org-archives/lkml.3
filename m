Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3EITnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:43:51 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:59154 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3EITnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <1361319761-23873-5-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com> <1361319761-23873-5-git-send-email-koverstreet@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 9 May 2013 12:43:29 -0700
Message-ID: <CAErSpo5-wVvBivB4pr8_hg2WdzW_yxodcTkSfssJcfEB6Cyd9Q@mail.gmail.com>
Subject: Re: [PATCH 04/27] block: Convert integrity to bvec_alloc_bs()
To: Kent Overstreet <koverstreet@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 4:22 PM, Kent Overstreet <koverstreet@google.com> wrote:

> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index 94fa1c5..8c4c604 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> ...
> @@ -766,13 +733,14 @@ void bioset_integrity_free(struct bio_set *bs)
>  {
>         if (bs->bio_integrity_pool)
>                 mempool_destroy(bs->bio_integrity_pool);
> +
> +       if (bs->bvec_integrity_pool)
> +               mempool_destroy(bs->bio_integrity_pool);

I think this is a copy-and-paste error that results in using
bs->bio_integrity_pool after it has been freed.  Found by Coverity
(CID 1020654).

>  }
>  EXPORT_SYMBOL(bioset_integrity_free);
