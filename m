Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaFBQr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:47:26 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40292 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaFBQrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:47:24 -0400
MIME-Version: 1.0
In-Reply-To: <538C2C49.9060000@vodafone.de>
References: <1401577805-4609-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<538C2C49.9060000@vodafone.de>
Date: Mon, 2 Jun 2014 18:47:23 +0200
Message-ID: <CAFo99gZNzKhYbGHksdKNb35YO4tA+4jdk4m5aBO812ujQPBz8w@mail.gmail.com>
Subject: Re: [PATCH] gpu: drm: radeon: r600_cp.c: Cleaning up uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thanks for your response!

No, it does not sound like it's worth changing anything.
Although in the worst case with this patch you probably have a more
consistent error :)



Best regards
Rickard Strandqvist


2014-06-02 9:48 GMT+02:00 Christian König <deathsimple@vodafone.de>:
> Am 01.06.2014 01:10, schrieb Rickard Strandqvist:
>
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called
>> cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>
>
> On the one hand it looks like a valid fix to me, but on the other hand the
> r600_cp.c code is deprecated for something like five years now.
>
> I would like to avoid touching it in any way and just let it rest peacefully
> until we can remove it entirely.
>
> Christian.
>
>
>> ---
>>   drivers/gpu/drm/radeon/r600_cp.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/r600_cp.c
>> b/drivers/gpu/drm/radeon/r600_cp.c
>> index 8c9b7e2..0770ad6 100644
>> --- a/drivers/gpu/drm/radeon/r600_cp.c
>> +++ b/drivers/gpu/drm/radeon/r600_cp.c
>> @@ -2615,7 +2615,7 @@ int r600_cs_legacy_ioctl(struct drm_device *dev,
>> void *data, struct drm_file *fp
>>         struct drm_radeon_cs *cs = data;
>>         struct drm_buf *buf;
>>         unsigned family;
>> -       int l, r = 0;
>> +       int l = 0, r = 0;
>>         u32 *ib, cs_id = 0;
>>         if (dev_priv == NULL) {
>
>
