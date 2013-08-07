Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3HGPui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:50:38 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:53622 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753806Ab3HGPuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:50:35 -0400
MIME-Version: 1.0
In-Reply-To: <52025BE3.5020002@redhat.com>
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com>
 <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 7 Aug 2013 08:50:13 -0700
X-Google-Sender-Auth: ZVdnoUfcZrpUsI3YiKIFxYdZ2Zc
Message-ID: <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
To: David Milburn <dmilburn@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>,
        James Bottomley <JBottomley@parallels.com>,
        Costa Sapuntzakis <costa@purestorage.com>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 7:38 AM, David Milburn <dmilburn@redhat.com> wrote:
> I was able to succesfully test this patch overnight, I had been experimenting with the
> sg driver setting the BIO_NULL_MAPPED flag in sg_rq_end_io_usercontext for a orphan process
> which prevented the corruption, but your solution seems much better.

Very cool, thanks for the testing.

I actually looked at using BIO_NULL_MAPPED as well, but it seemed a
bit too fragile to me -- it had the right effect of skipping
__bio_copy_iov(), and skipping the __free_pages() stuff in there is OK
because sg owns its pages rather than the bio layer, but all that
seemed vulnerable to being broken by an unrelated change.

Out of curiousity, were you already working on this bug?  Because if
you had fixed it a few weeks earlier we might not have spent so long
wondering WTF was stomping on the memory of one of our processes :)

 - R.
