Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3IQSre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:47:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3IQSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:47:32 -0400
Message-ID: <5238A3AD.6020201@kernel.dk>
Date: Tue, 17 Sep 2013 12:47:09 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Kent Overstreet <koverstreet@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] bio-integrity: Fix use of bs->bio_integrity_pool after
 free
References: <20130529222955.10627.50429.stgit@bhelgaas-glaptop> <CAErSpo7s1m=6WvgeVOQ3Zj=mU8=+13pT4hJ8k5-KkrDDGOU+5w@mail.gmail.com> <20130613183315.GH10979@localhost> <CAErSpo6475cSMDtdk2ywFUUyb_szOFVdUy9Pm0DjnRTuiCVPhw@mail.gmail.com>
In-Reply-To: <CAErSpo6475cSMDtdk2ywFUUyb_szOFVdUy9Pm0DjnRTuiCVPhw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 07:40 AM, Bjorn Helgaas wrote:
> On Thu, Jun 13, 2013 at 12:33 PM, Kent Overstreet
> <koverstreet@google.com> wrote:
>> On Thu, Jun 13, 2013 at 12:14:54PM -0600, Bjorn Helgaas wrote:
>>> On Wed, May 29, 2013 at 4:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> This fixes a copy and paste error introduced by 9f060e2231
>>>> ("block: Convert integrity to bvec_alloc_bs()").
>>>>
>>>> Found by Coverity (CID 1020654).
>>>>
>>>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>>> ---
>>>>  fs/bio-integrity.c |    2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
>>>> index 8fb4291..45e944f 100644
>>>> --- a/fs/bio-integrity.c
>>>> +++ b/fs/bio-integrity.c
>>>> @@ -734,7 +734,7 @@ void bioset_integrity_free(struct bio_set *bs)
>>>>                 mempool_destroy(bs->bio_integrity_pool);
>>>>
>>>>         if (bs->bvec_integrity_pool)
>>>> -               mempool_destroy(bs->bio_integrity_pool);
>>>> +               mempool_destroy(bs->bvec_integrity_pool);
>>>>  }
>>>>  EXPORT_SYMBOL(bioset_integrity_free);
>>>
>>> Kent, do you want to chime in on this?  Looks like an obvious error to
>>> me, but maybe I'm missing something and we should teach Coverity to
>>> shut up about it.
>>
>> Sorry - no, this is definitely a bug:
>>
>> Acked-by: Kent Overstreet <koverstreet@google.com>
> 
> From my v3.12-rc1 reminder list: what's going on with this patch?
> 
> It's been acked, Gu asked whether he could include it in some
> patchset, I see a Sep 11 2013 patch from Gu upstream already
> (bc5c8f078), but this patch (from May 29 2013) still hasn't gone
> anywhere.  Why is this so hard?

Queued up.

-- 
Jens Axboe

