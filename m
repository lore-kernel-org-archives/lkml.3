Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab3HGQRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:17:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab3HGQRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:17:32 -0400
Message-ID: <52027311.9060904@redhat.com>
Date: Wed, 07 Aug 2013 11:17:21 -0500
From: David Milburn <dmilburn@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20081113)
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>,
        James Bottomley <JBottomley@parallels.com>,
        Costa Sapuntzakis <costa@purestorage.com>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com> <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com> <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com>
In-Reply-To: <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> On Wed, Aug 7, 2013 at 7:38 AM, David Milburn <dmilburn@redhat.com> wrote:
>> I was able to succesfully test this patch overnight, I had been experimenting with the
>> sg driver setting the BIO_NULL_MAPPED flag in sg_rq_end_io_usercontext for a orphan process
>> which prevented the corruption, but your solution seems much better.
> 
> Very cool, thanks for the testing.
> 
> I actually looked at using BIO_NULL_MAPPED as well, but it seemed a
> bit too fragile to me -- it had the right effect of skipping
> __bio_copy_iov(), and skipping the __free_pages() stuff in there is OK
> because sg owns its pages rather than the bio layer, but all that
> seemed vulnerable to being broken by an unrelated change.
> 
> Out of curiousity, were you already working on this bug?  Because if
> you had fixed it a few weeks earlier we might not have spent so long
> wondering WTF was stomping on the memory of one of our processes :)
> 

Hi Roland,

Actually, I was waiting for confirmation from the field which I
recently received, I was getting ready to bring this up on linux-scsi,
sorry I should have brought it up sooner. I wasn't positive that setting
BIO_NULL_MAPPED flag from sg driver was the fix. David Jeffery
came up with a reproducer which I ran overnight on the latest
upstream kernel with your patch.

Thanks,
David



