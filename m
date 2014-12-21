Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaLULYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:24:13 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:43658 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaLULYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:24:09 -0500
MIME-Version: 1.0
In-Reply-To: <652559297.245180.1419129995022.JavaMail.zimbra@redhat.com>
References: <1419094456-9446-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <652559297.245180.1419129995022.JavaMail.zimbra@redhat.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 21 Dec 2014 12:23:47 +0100
Message-ID: <CAFo99gazbgQ+GFn1Jhegdk7TP-ohbtUm9W1ykdbpXNW840rERQ@mail.gmail.com>
Subject: Re: [PATCH] gpu: drm: nouveau: core: subdev: clock: base.c: Remove
 unused function
To: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>, Alexandre Courbot <acourbot@nvidia.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-21 3:46 GMT+01:00 Ben Skeggs <bskeggs@redhat.com>:
> ----- Original Message -----
>> From: "Rickard Strandqvist" <rickard_strandqvist@spectrumdigital.se>
>> To: "David Airlie" <airlied@linux.ie>, "Ben Skeggs" <bskeggs@redhat.com>
>> Cc: "Rickard Strandqvist" <rickard_strandqvist@spectrumdigital.se>, "Alexandre Courbot" <acourbot@nvidia.com>, "Ilia
>> Mirkin" <imirkin@alum.mit.edu>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
>> Sent: Sunday, 21 December, 2014 2:54:16 AM
>> Subject: [PATCH] gpu: drm: nouveau: core: subdev: clock: base.c:  Remove unused function
>>
>> Remove the function nouveau_clock_astate() that is not used anywhere.
> No, don't remove this.  It's only not used because noone got around to finishing load-based reclocking yet.
>
> NVIDIA has an implementation for the GK20A in the works that uses it.
>
> Ben.
>
>>
>> This was partially found by using a static code analysis program called
>> cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/gpu/drm/nouveau/core/include/subdev/clock.h |    1 -
>>  drivers/gpu/drm/nouveau/core/subdev/clock/base.c    |   10 ----------
>>  2 files changed, 11 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
>> b/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
>> index 36ed035..8577945 100644
>> --- a/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
>> +++ b/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
>> @@ -159,7 +159,6 @@ int nva3_clock_pll_calc(struct nouveau_clock *, struct
>> nvbios_pll *,
>>                       int clk, struct nouveau_pll_vals *);
>>
>>  int nouveau_clock_ustate(struct nouveau_clock *, int req, int pwr);
>> -int nouveau_clock_astate(struct nouveau_clock *, int req, int rel);
>>  int nouveau_clock_dstate(struct nouveau_clock *, int req, int rel);
>>  int nouveau_clock_tstate(struct nouveau_clock *, int req, int rel);
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> index e51b72d..b2c852a 100644
>> --- a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> +++ b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
>> @@ -430,16 +430,6 @@ nouveau_clock_ustate(struct nouveau_clock *clk, int req,
>> int pwr)
>>  }
>>
>>  int
>> -nouveau_clock_astate(struct nouveau_clock *clk, int req, int rel)
>> -{
>> -     if (!rel) clk->astate  = req;
>> -     if ( rel) clk->astate += rel;
>> -     clk->astate = min(clk->astate, clk->state_nr - 1);
>> -     clk->astate = max(clk->astate, 0);
>> -     return nouveau_pstate_calc(clk, true);
>> -}
>> -
>> -int
>>  nouveau_clock_tstate(struct nouveau_clock *clk, int req, int rel)
>>  {
>>       if (!rel) clk->tstate  = req;
>> --
>> 1.7.10.4
>>


Hi

Ok, sorry.
But maybe there should be a comment on the function.

Kind regards
Rickard Strandqvist
