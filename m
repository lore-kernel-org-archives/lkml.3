Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937343Ab3DIKEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:04:09 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54689 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934845Ab3DIKEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <5163E603.3030103@ti.com>
References: <1365423553-12619-1-git-send-email-prabhakar.csengg@gmail.com>
 <1365423553-12619-3-git-send-email-prabhakar.csengg@gmail.com> <5163E603.3030103@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 9 Apr 2013 15:33:44 +0530
Message-ID: <CA+V-a8vFOh3m1jCBCZmHJyU0+fQFTrj1+cfFAOP4LSCCbY8cBA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] media: davinci: vpbe: venc: move the enabling of
 vpss clocks to driver
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:27 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>
>
> On 4/8/2013 5:49 PM, Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> The vpss clocks were enabled by calling a exported function from a driver
>> in a machine code. calling driver code from platform code is incorrect way.
>>
>> This patch fixes this issue and calls the function from driver code itself.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/davinci/vpbe_venc.c |   25 +++++++++++++++++++++++++
>>  1 files changed, 25 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
>> index f15f211..91d0272 100644
>> --- a/drivers/media/platform/davinci/vpbe_venc.c
>> +++ b/drivers/media/platform/davinci/vpbe_venc.c
>> @@ -202,6 +202,25 @@ static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
>>       }
>>  }
>>
>> +static void
>> +venc_enable_vpss_clock(int venc_type,
>> +                    enum vpbe_enc_timings_type type,
>> +                    unsigned int pclock)
>> +{
>> +     if (venc_type == VPBE_VERSION_1)
>> +             return;
>> +
>> +     if (venc_type == VPBE_VERSION_2 && (type == VPBE_ENC_STD ||
>> +         (type == VPBE_ENC_DV_TIMINGS && pclock <= 27000000))) {
>
> checkpatch --strict will throw a "Alignment should match open
> parenthesis" check here. You may want to fix before you send the pull
> request. No need to resend the patch just for this.
>
OK, thanks will fix it while issuing the pull.

Regards,
--Prabhakar

> Thanks,
> Sekhar
