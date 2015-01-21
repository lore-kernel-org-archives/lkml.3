Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbbAULaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:30:07 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34379 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbAULaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:30:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAHG8p1D4HAbM-JVDa_P81EA1TeSYZ_Wi5=uYH5VvnmLiR+dHeA@mail.gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
 <1419072462-3168-6-git-send-email-prabhakar.csengg@gmail.com> <CAHG8p1D4HAbM-JVDa_P81EA1TeSYZ_Wi5=uYH5VvnmLiR+dHeA@mail.gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 21 Jan 2015 11:29:29 +0000
Message-ID: <CA+V-a8sAFPabRRUUwfZUG4zW-YYKKj5SfoLJ0ptVn=x4qNrGxw@mail.gmail.com>
Subject: Re: [PATCH 05/15] media: blackfin: bfin_capture: improve
 queue_setup() callback
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:01 AM, Scott Jiang
<scott.jiang.linux@gmail.com> wrote:
> 2014-12-20 18:47 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
>> this patch improves the queue_setup() callback.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/blackfin/bfin_capture.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
>> index 8bd94a1..76d42bb 100644
>> --- a/drivers/media/platform/blackfin/bfin_capture.c
>> +++ b/drivers/media/platform/blackfin/bfin_capture.c
>> @@ -44,7 +44,6 @@
>>  #include <media/blackfin/ppi.h>
>>
>>  #define CAPTURE_DRV_NAME        "bfin_capture"
>> -#define BCAP_MIN_NUM_BUF        2
>>
>>  struct bcap_format {
>>         char *desc;
>> @@ -292,11 +291,14 @@ static int bcap_queue_setup(struct vb2_queue *vq,
>>  {
>>         struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
>>
>> -       if (*nbuffers < BCAP_MIN_NUM_BUF)
>> -               *nbuffers = BCAP_MIN_NUM_BUF;
>> +       if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
>> +               return -EINVAL;
>> +
>> +       if (vq->num_buffers + *nbuffers < 3)
>> +               *nbuffers = 3 - vq->num_buffers;
>
> It seems it changes the minimum buffers from 2 to 3?
>
will replace it with,

if (vq->num_buffers + *nbuffers < 2)
       *nbuffers = 2;

Thanks,
--Prabhakar Lad
