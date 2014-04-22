Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaDVB6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:58:50 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:45577 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaDVB6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAKb7Uvg4kOfsE0gd4zLcwjShc4eVgVKA7zQM2r1aeatOybm8NQ@mail.gmail.com>
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
	<1398060142-7937-10-git-send-email-acourbot@nvidia.com>
	<CAKb7Uvg4kOfsE0gd4zLcwjShc4eVgVKA7zQM2r1aeatOybm8NQ@mail.gmail.com>
Date: Tue, 22 Apr 2014 11:58:48 +1000
Message-ID: <CACAvsv4Dzx8DVbR+QVWFtw8h8ktey8OdiPA4bd8Xqmhvi5Vv8Q@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v2 09/10] drm/nouveau: support GK20A in nouveau_accel_init()
From: Ben Skeggs <skeggsb@gmail.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 4:07 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Mon, Apr 21, 2014 at 2:02 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Skip the creation of a software channel for GK20A as software methods
>> are not yet supported.
>
> How is GK20A different from a nvc0+ card that lacks PDISPLAY (like all
> the 3D Controller ones, and I guess even some that come up as VGA
> controller in PCI but don't have any outputs in their VBIOS)? i.e.
> what's wrong with just doing the same thing that GK1xx does? Note that
> there are sw methods that don't deal with display as well.
The mp_control() methods are the only ones I see, and, in my opinion,
they should really have been implemented using reserved methods on a
graphics class, and *not* in a purely software object..  If we need
them on GK20A too, we should reimplement them in gr, and bump the
minor version number so userspace knows.

Ben.

>
>   -ilia
>
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/nouveau_drm.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
>> index ddd83756b9a2..5b46148ffd32 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_drm.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
>> @@ -208,6 +208,10 @@ nouveau_accel_init(struct nouveau_drm *drm)
>>                 return;
>>         }
>>
>> +       /* Need to figure out how to handle sw for gk20a */
>> +       if (device->chipset == 0xea)
>> +               goto skip_sw_init;
>> +
>>         ret = nouveau_object_new(nv_object(drm), NVDRM_CHAN, NVDRM_NVSW,
>>                                  nouveau_abi16_swclass(drm), NULL, 0, &object);
>>         if (ret == 0) {
>> @@ -234,6 +238,7 @@ nouveau_accel_init(struct nouveau_drm *drm)
>>                 return;
>>         }
>>
>> +skip_sw_init:
>>         if (device->card_type < NV_C0) {
>>                 ret = nouveau_gpuobj_new(drm->device, NULL, 32, 0, 0,
>>                                         &drm->notify);
>> --
>> 1.9.2
>>
>> _______________________________________________
>> Nouveau mailing list
>> Nouveau@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/nouveau
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
