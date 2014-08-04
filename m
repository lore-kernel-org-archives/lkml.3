Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaHDFHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 01:07:46 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58925 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHDFHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 01:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <53DF1412.9010506@xs4all.nl>
References: <1407122751-30689-1-git-send-email-xerofoify@gmail.com>
	<53DF1412.9010506@xs4all.nl>
Date: Mon, 4 Aug 2014 01:07:43 -0400
Message-ID: <CAPDOMVhiduQRCe-+jA6wZqj2=_Q52agHpEUuZM0_GTREVjiuHw@mail.gmail.com>
Subject: Re: [PATCH] v4l2: Change call of function in videobuf2-core.c
From: Nick Krause <xerofoify@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 1:03 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 08/04/2014 05:25 AM, Nicholas Krause wrote:
>> This patch changes the call of vb2_buffer_core to use VB2_BUFFER_STATE_ACTIVE
>> inside the for instead of not setting in correctly to VB2_BUFFER_STATE_ERROR.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>
> Dunno what's going on here after reading Dave Airlie's reply, but:
>
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> It's clearly wrong and if you get here at all you have a driver bug anyway. That
> WARN_ON is there for a reason. Your driver isn't returning buffers correctly in
> stop_streaming or in start_streaming if start_streaming fails with an error.
>
> Regards,
>
>         Hans
>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 7c4489c..08e478b 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -2115,7 +2115,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>>       if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>>               for (i = 0; i < q->num_buffers; ++i)
>>                       if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
>> -                             vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
>> +                             vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ACTIVE);
>>               /* Must be zero now */
>>               WARN_ON(atomic_read(&q->owned_by_drv_count));
>>       }
>>
>

Yes ,
That was an idiot mistake. So sorry about that would someone mind as a
big help a list of
common debugging macros or a link to somewhere I can read them. I want
to apologize
sincerely for my bad mistakes. I do want to help out and by helping me
sand out my
mistakes and learn from them I can help much better. I do want to help
and if people
are willing to get me grow like this I will continue to try and help.
Regards Nick
