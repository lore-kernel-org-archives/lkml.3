Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaGYGG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:06:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:8123 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbaGYGGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:06:54 -0400
X-IronPort-AV: E=Sophos;i="5.00,959,1396972800"; 
   d="scan'208";a="33765591"
Message-ID: <53D1F11E.80708@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 13:54:38 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list:
	AIO <linux-aio@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH 2/4] aio: use the macro rather than the inline magic number
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com> <1405996804-8262-2-git-send-email-guz.fnst@cn.fujitsu.com> <x49vbqp7b3p.fsf@segfault.boston.devel.redhat.com> <CACVXFVOv1TShu=s40KvVLMTfk4b2ktZ0xmDUPyiO+7=BqOcSrw@mail.gmail.com>
In-Reply-To: <CACVXFVOv1TShu=s40KvVLMTfk4b2ktZ0xmDUPyiO+7=BqOcSrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lei,
On 07/25/2014 11:13 AM, Ming Lei wrote:

> On Tue, Jul 22, 2014 at 9:54 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
>>
>>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>>
>>> ---
>>>  fs/aio.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/aio.c b/fs/aio.c
>>> index ad35876..1dc6158 100644
>>> --- a/fs/aio.c
>>> +++ b/fs/aio.c
>>> @@ -201,7 +201,7 @@ static struct dentry *aio_mount(struct file_system_type *fs_type,
>>>       static const struct dentry_operations ops = {
>>>               .d_dname        = simple_dname,
>>>       };
>>> -     return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
>>> +     return mount_pseudo(fs_type, "aio:", NULL, &ops, AIO_RING_MAGIC);
> 
> IMO, it might be better to use a new macro like AIO_FS_MAGIC
> with same number here because the same magic number
> 0xa10a10a1 serves for two purposes.

Sounds reasonable, but I prefer a more common name like
AIO_MAGIC to serve two if we need.:)

Thanks,
Gu

> 
> Thanks,
> .
> 


