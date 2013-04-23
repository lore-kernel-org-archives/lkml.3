Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3DWFQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:16:30 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44301 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3DWFQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:16:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130422212324.GB4704@localhost>
References: <1366389602-19313-1-git-send-email-linkinjeon@gmail.com>
	<20130422212324.GB4704@localhost>
Date: Tue, 23 Apr 2013 14:16:28 +0900
Message-ID: <CAKYAXd-PUJ2YXr7QMMw9HWzSXzOO=Yb_CCo7AyfrT-_MP5Sa6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] fix max discard sectors limit
From: Namjae Jeon <linkinjeon@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com,
        James.Bottomley@hansenpartnership.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcmvbkbc@gmail.com, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/23, Kent Overstreet <koverstreet@google.com>:
> On Sat, Apr 20, 2013 at 01:40:02AM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
>> commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
>> (block: add plug for blkdev_issue_discard )
>>
>> For example,
>> 1) DISCARD rq-1 with size size 4GB
>> 2) DISCARD rq-2 with size size 1GB
>>
>> If these 2 discard requests get merged, final request size will be 5GB.
>>
>> In this case, request's __data_len field may overflow as it can store
>> max 4GB(unsigned int).
>
> Complete NACK - like James said, this fix is nonsensical. This should be
> fixed by just checking for overflow before merging requests, not with
> weird hacks in the drivers.
that agree to your opinion, and will change at only appropriate
place(James'change) and will send the updated patch soon.
Thanks.
>
