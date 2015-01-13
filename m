Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbbAMWtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:49:53 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58368 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbAMWtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:49:52 -0500
MIME-Version: 1.0
In-Reply-To: <CACAvsv7zabywpQcyq_5L49JWxi83Kg=ay_Du40J=+gRxFUMg4Q@mail.gmail.com>
References: <1420984409-17330-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CACAvsv7zabywpQcyq_5L49JWxi83Kg=ay_Du40J=+gRxFUMg4Q@mail.gmail.com>
Date: Tue, 13 Jan 2015 23:49:51 +0100
Message-ID: <CAKXHbyOYST6-RkqX5kPegMVuyf9ZC+YuU7TdL_cX7GEV=vz2-Q@mail.gmail.com>
Subject: Re: [PATCH] gpu: drm: nouveau: nvif: device: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-12 0:13 GMT+01:00 Ben Skeggs <skeggsb@gmail.com>:
> On Sun, Jan 11, 2015 at 11:53 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>
> Hey Rickard,
>
>> Remove the function nvif_device_new() that is not used anywhere.
> It's used, just not by the kernel.  All the code under core/ and nvif/
> is also built into a userspace library (not in the kernel tree,
> obviously) and used by tools / testing apps.
>
> I'll pick up the rest of your nouveau patches though, aside from the
> one Samuel is taking care of.
>
> Thanks,
> Ben.
>
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/gpu/drm/nouveau/nvif/device.c |   18 ------------------
>>  drivers/gpu/drm/nouveau/nvif/device.h |    2 --
>>  2 files changed, 20 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nvif/device.c b/drivers/gpu/drm/nouveau/nvif/device.c
>> index f477579..8522aa9 100644
>> --- a/drivers/gpu/drm/nouveau/nvif/device.c
>> +++ b/drivers/gpu/drm/nouveau/nvif/device.c
>> @@ -53,24 +53,6 @@ nvif_device_del(struct nvif_device *device)
>>         kfree(device);
>>  }
>>
>> -int
>> -nvif_device_new(struct nvif_object *parent, u32 handle, u32 oclass,
>> -               void *data, u32 size, struct nvif_device **pdevice)
>> -{
>> -       struct nvif_device *device = kzalloc(sizeof(*device), GFP_KERNEL);
>> -       if (device) {
>> -               int ret = nvif_device_init(parent, nvif_device_del, handle,
>> -                                          oclass, data, size, device);
>> -               if (ret) {
>> -                       kfree(device);
>> -                       device = NULL;
>> -               }
>> -               *pdevice = device;
>> -               return ret;
>> -       }
>> -       return -ENOMEM;
>> -}
>> -
>>  void
>>  nvif_device_ref(struct nvif_device *device, struct nvif_device **pdevice)
>>  {
>> diff --git a/drivers/gpu/drm/nouveau/nvif/device.h b/drivers/gpu/drm/nouveau/nvif/device.h
>> index 43180f9..8440848 100644
>> --- a/drivers/gpu/drm/nouveau/nvif/device.h
>> +++ b/drivers/gpu/drm/nouveau/nvif/device.h
>> @@ -22,8 +22,6 @@ int  nvif_device_init(struct nvif_object *, void (*dtor)(struct nvif_device *),
>>                       u32 handle, u32 oclass, void *, u32,
>>                       struct nvif_device *);
>>  void nvif_device_fini(struct nvif_device *);
>> -int  nvif_device_new(struct nvif_object *, u32 handle, u32 oclass,
>> -                    void *, u32, struct nvif_device **);
>>  void nvif_device_ref(struct nvif_device *, struct nvif_device **);
>>
>>  /*XXX*/
>> --
>> 1.7.10.4
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel


Hi Ben

Okay, thanks good to know.


Kind regards
Rickard Strandqvist
