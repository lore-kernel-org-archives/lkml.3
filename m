Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993Ab3JPQnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:43:00 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:47756 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3JPQm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <s5hd2n5uq33.wl%tiwai@suse.de>
References: <1381940506-29855-1-git-send-email-geyslan@gmail.com>
	<s5hd2n5uq33.wl%tiwai@suse.de>
Date: Wed, 16 Oct 2013 13:42:58 -0300
Message-ID: <CAGG-pUTOH8gd27VrzezDE+SO4wOSFe7kYzsZRK252rG+v3bfrg@mail.gmail.com>
Subject: Re: [PATCH] sound: pci: emu10k1: Remove useless casting in emufx.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-br <kernel-br@googlegroups.com>, Jaroslav Kysela <perex@perex.cz>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "moderated list:SOUND" <alsa-devel@alsa-project.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/16 Takashi Iwai <tiwai@suse.de>:
> At Wed, 16 Oct 2013 13:21:45 -0300,
> Geyslan G. Bem wrote:
>>
>> Casting (void *) value returned by kcalloc is useless
>> as mentioned in Documentation/CodingStyle, Chap 14.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>
> You missed __user prefix.  You can't cast user and kernel pointers
> implicitly.
>
>
> Takashi
>

Takashi,

My mistake, I'll fix that later.

Thank you.

>> ---
>>  sound/pci/emu10k1/emufx.c | 12 +++++-------
>>  1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
>> index 0275209..3f51dac 100644
>> --- a/sound/pci/emu10k1/emufx.c
>> +++ b/sound/pci/emu10k1/emufx.c
>> @@ -1183,9 +1183,8 @@ static int _snd_emu10k1_audigy_init_efx(struct snd_emu10k1 *emu)
>>       mm_segment_t seg;
>>
>>       if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL ||
>> -         (icode->gpr_map = (u_int32_t __user *)
>> -          kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
>> -                  GFP_KERNEL)) == NULL ||
>> +         (icode->gpr_map = kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
>> +                                   GFP_KERNEL)) == NULL ||
>>           (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
>>                               sizeof(*controls), GFP_KERNEL)) == NULL) {
>>               err = -ENOMEM;
>> @@ -1815,10 +1814,9 @@ static int _snd_emu10k1_init_efx(struct snd_emu10k1 *emu)
>>
>>       if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL)
>>               return -ENOMEM;
>> -     if ((icode->gpr_map = (u_int32_t __user *)
>> -          kcalloc(256 + 160 + 160 + 2 * 512, sizeof(u_int32_t),
>> -                  GFP_KERNEL)) == NULL ||
>> -            (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
>> +     if ((icode->gpr_map = kcalloc(256 + 160 + 160 + 2 * 512, sizeof(u_int32_t),
>> +                                   GFP_KERNEL)) == NULL ||
>> +         (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
>>                               sizeof(struct snd_emu10k1_fx8010_control_gpr),
>>                               GFP_KERNEL)) == NULL ||
>>           (ipcm = kzalloc(sizeof(*ipcm), GFP_KERNEL)) == NULL) {
>> --
>> 1.8.4
>>
