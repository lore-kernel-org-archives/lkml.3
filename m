Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbaGYDNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 23:13:20 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52402 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698AbaGYDNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 23:13:17 -0400
MIME-Version: 1.0
In-Reply-To: <x49vbqp7b3p.fsf@segfault.boston.devel.redhat.com>
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<1405996804-8262-2-git-send-email-guz.fnst@cn.fujitsu.com>
	<x49vbqp7b3p.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 25 Jul 2014 11:13:16 +0800
Message-ID: <CACVXFVOv1TShu=s40KvVLMTfk4b2ktZ0xmDUPyiO+7=BqOcSrw@mail.gmail.com>
Subject: Re: [PATCH 2/4] aio: use the macro rather than the inline magic number
From: Ming Lei <tom.leiming@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:AIO" <linux-aio@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 9:54 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>
>> ---
>>  fs/aio.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index ad35876..1dc6158 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -201,7 +201,7 @@ static struct dentry *aio_mount(struct file_system_type *fs_type,
>>       static const struct dentry_operations ops = {
>>               .d_dname        = simple_dname,
>>       };
>> -     return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
>> +     return mount_pseudo(fs_type, "aio:", NULL, &ops, AIO_RING_MAGIC);

IMO, it might be better to use a new macro like AIO_FS_MAGIC
with same number here because the same magic number
0xa10a10a1 serves for two purposes.

Thanks,
