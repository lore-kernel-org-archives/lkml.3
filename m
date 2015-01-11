Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbbAKWGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:06:07 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57922 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbbAKWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:06:02 -0500
MIME-Version: 1.0
In-Reply-To: <54B2E455.7050707@gmail.com>
References: <1420999965-22216-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54B2E455.7050707@gmail.com>
Date: Sun, 11 Jan 2015 23:05:59 +0100
Message-ID: <CAKXHbyMcXwdwL-tgaypqzTJiXuC6O3uyjXRtWb9AwPi_sZeDbg@mail.gmail.com>
Subject: Re: [PATCH] drm: nouveau: core: engine: perfmon: base: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Samuel Pitoiset <samuel.pitoiset@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-11 22:00 GMT+01:00 Samuel Pitoiset <samuel.pitoiset@gmail.com>:
> Hi Rickard,
>
> Thanks for submitting this patch, but I already submitted the same a few
> weeks ago. :-)
>
> This function will be removed when I will submit my work on this area.
>
> Greetings,
> Samuel Pitoiset.
>
>
> On 01/11/2015 07:12 PM, Rickard Strandqvist wrote:
>>
>> Remove the function nouveau_perfsig_wrap() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called
>> cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   drivers/gpu/drm/nouveau/core/engine/perfmon/base.c |   20
>> --------------------
>>   drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h |    5 -----
>>   2 files changed, 25 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
>> b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
>> index 6301381..d0c5255 100644
>> --- a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
>> +++ b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
>> @@ -80,26 +80,6 @@ nouveau_perfsig_find(struct nouveau_perfmon *ppm, const
>> char *name, u32 size,
>>         return nouveau_perfsig_find_(dom, name, size);
>>   }
>>   -struct nouveau_perfctr *
>> -nouveau_perfsig_wrap(struct nouveau_perfmon *ppm, const char *name,
>> -                    struct nouveau_perfdom **pdom)
>> -{
>> -       struct nouveau_perfsig *sig;
>> -       struct nouveau_perfctr *ctr;
>> -
>> -       sig = nouveau_perfsig_find(ppm, name, strlen(name), pdom);
>> -       if (!sig)
>> -               return NULL;
>> -
>> -       ctr = kzalloc(sizeof(*ctr), GFP_KERNEL);
>> -       if (ctr) {
>> -               ctr->signal[0] = sig;
>> -               ctr->logic_op = 0xaaaa;
>> -       }
>> -
>> -       return ctr;
>> -}
>> -
>>
>> /*******************************************************************************
>>    * Perfmon object classes
>>
>> ******************************************************************************/
>> diff --git a/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
>> b/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
>> index 0ac8714..1a0989e 100644
>> --- a/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
>> +++ b/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
>> @@ -30,11 +30,6 @@ struct nouveau_perfsig {
>>         const char *name;
>>   };
>>   -struct nouveau_perfdom;
>> -struct nouveau_perfctr *
>> -nouveau_perfsig_wrap(struct nouveau_perfmon *, const char *,
>> -                    struct nouveau_perfdom **);
>> -
>>   struct nouveau_specdom {
>>         u16 signal_nr;
>>         const struct nouveau_specsig *signal;
>
>


Hi Samuel

Thanks, another of the drawbacks that I start this off too long ago :(


Kind regards
Rickard Strandqvist
