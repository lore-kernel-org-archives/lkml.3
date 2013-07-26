Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab3GZO0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:26:13 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51386 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3GZO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:26:11 -0400
MIME-Version: 1.0
In-Reply-To: <51F24809.2080401@xs4all.nl>
References: <1374076022-10960-1-git-send-email-prabhakar.csengg@gmail.com> <51F24809.2080401@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 26 Jul 2013 19:55:49 +0530
Message-ID: <CA+V-a8v3HvFzG3JDuTP-NtjhUMs6-bR9GKcLze3tdO4_YKvXEQ@mail.gmail.com>
Subject: Re: [PATCH RFC FINAL v5] media: OF: add "sync-on-green-active" property
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Fri, Jul 26, 2013 at 3:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> On 07/17/2013 05:47 PM, Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch adds 'sync-on-green-active' property as part
>> of endpoint property.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>   Changes for v5:
>>   1: Changed description for sync-on-green-active property in
>>      documentation file as suggested by Sylwester.
>>
>>   Changes for v4:
>>   1: Fixed review comments pointed by Sylwester.
>>
>>   Changes for v3:
>>   1: Fixed review comments pointed by Laurent and Sylwester.
>>
>>   RFC v2 https://patchwork.kernel.org/patch/2578091/
>>
>>   RFC V1 https://patchwork.kernel.org/patch/2572341/
>>
>>  .../devicetree/bindings/media/video-interfaces.txt |    2 ++
>>  drivers/media/v4l2-core/v4l2-of.c                  |    4 ++++
>>  include/media/v4l2-mediabus.h                      |    2 ++
>>  3 files changed, 8 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> index e022d2d..ce719f8 100644
>> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> @@ -88,6 +88,8 @@ Optional endpoint properties
>>  - field-even-active: field signal level during the even field data transmission.
>>  - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
>>    signal.
>> +- sync-on-green-active: active state of Sync-on-green (SoG) signal, 0/1 for
>> +  LOW/HIGH respectively.
>>  - data-lanes: an array of physical data lane indexes. Position of an entry
>>    determines the logical lane number, while the value of an entry indicates
>>    physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
>> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
>> index aa59639..5c4c9f0 100644
>> --- a/drivers/media/v4l2-core/v4l2-of.c
>> +++ b/drivers/media/v4l2-core/v4l2-of.c
>> @@ -100,6 +100,10 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>>       if (!of_property_read_u32(node, "data-shift", &v))
>>               bus->data_shift = v;
>>
>> +     if (!of_property_read_u32(node, "sync-on-green-active", &v))
>> +             flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
>> +                     V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
>> +
>>       bus->flags = flags;
>>
>>  }
>> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
>> index 83ae07e..d47eb81 100644
>> --- a/include/media/v4l2-mediabus.h
>> +++ b/include/media/v4l2-mediabus.h
>> @@ -40,6 +40,8 @@
>>  #define V4L2_MBUS_FIELD_EVEN_HIGH            (1 << 10)
>>  /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
>>  #define V4L2_MBUS_FIELD_EVEN_LOW             (1 << 11)
>> +#define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH      (1 << 12)
>> +#define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW               (1 << 13)
>
> Can you add a short comment for these new flags? Similar to what you added in
> video-interfaces.txt?
>
OK will fix it and repost.

Regards,
--Prabhakar Lad
