Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbaDOJPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:15:24 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:60556 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaDOJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <1876072135.7241792.1397545235729.JavaMail.zimbra@redhat.com>
References: <3009531.aHrQhHYAOc@daeseok-laptop.cloud.net>
	<1876072135.7241792.1397545235729.JavaMail.zimbra@redhat.com>
Date: Tue, 15 Apr 2014 18:15:17 +0900
Message-ID: <CAHb8M2ACqHVwLZRhJ9xkBH6Q4g70FX0aH6WRR0qdqpmbRzKwjg@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/clk: fix possible NULL pointer dereference
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-15 16:00 GMT+09:00 Ben Skeggs <bskeggs@redhat.com>:
> ----- Original Message -----
>> From: "Daeseok Youn" <daeseok.youn@gmail.com>
>> To: airlied@linux.ie
>> Cc: bskeggs@redhat.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
>> Sent: Tuesday, 15 April, 2014 11:56:49 AM
>> Subject: [PATCH] drm/nouveau/clk: fix possible NULL pointer dereference
>>
>>
>> It need to be checking NULL before dereferencing.
> There's no dereference here.  It's an address calculation only.
Oh.. You're right.
But the address calculation doesn't need when "pstate" is NULL.
Can I re-send this patch after modifying subject and comment of this
patch properly?
Or drop this patch.

Thanks for review.

Regards,
Daeseok Youn.
>
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/gpu/drm/nouveau/core/subdev/clock/base.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> index dd62bae..a586d030 100644
>> --- a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> +++ b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> @@ -290,9 +290,9 @@ nouveau_pstate_new(struct nouveau_clock *clk, int idx)
>>               return 0;
>>
>>       pstate = kzalloc(sizeof(*pstate), GFP_KERNEL);
>> -     cstate = &pstate->base;
>>       if (!pstate)
>>               return -ENOMEM;
>> +     cstate = &pstate->base;
>>
>>       INIT_LIST_HEAD(&pstate->list);
>>
>> --
>> 1.7.4.4
>>
>>
>>
