Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3FXQJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:09:50 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34058 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3FXQJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:09:48 -0400
MIME-Version: 1.0
In-Reply-To: <201306240951.07426.hverkuil@xs4all.nl>
References: <1371913383-25088-1-git-send-email-prabhakar.csengg@gmail.com> <201306240951.07426.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 24 Jun 2013 21:39:26 +0530
Message-ID: <CA+V-a8uqo+YyRb8GFqftEka=KZf72WsS_hv36_0ShZOXvTv_Yg@mail.gmail.com>
Subject: Re: [PATCH RFC v3] media: OF: add video sync endpoint property
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Mon, Jun 24, 2013 at 1:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> On Sat June 22 2013 17:03:03 Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch adds video sync properties as part of endpoint
>> properties and also support to parse them in the parser.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>
> FYI: using my private email when CC-ing me generally works better.
> I often skip v4l2-related emails to my work address since I assume those
> have either been CC-ed to my private email and/or linux-media.
>
OK hence forth I'll take care of it.

> I wondered why I never saw RFC v1/2, now I know :-)
[Snip]
>>    clock mode.
>> +- video-sync: property indicating to sync the video on a signal in RGB.
>
> Please document what the various syncs actually mean.
>
OK

>>
>>
>>  Example
>> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
>> index aa59639..1a54530 100644
>> --- a/drivers/media/v4l2-core/v4l2-of.c
>> +++ b/drivers/media/v4l2-core/v4l2-of.c
>> @@ -100,6 +100,26 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>>       if (!of_property_read_u32(node, "data-shift", &v))
>>               bus->data_shift = v;
>>
>> +     if (!of_property_read_u32(node, "video-sync", &v)) {
>> +             switch (v) {
>> +             case V4L2_MBUS_VIDEO_SEPARATE_SYNC:
>> +                     flags |= V4L2_MBUS_VIDEO_SEPARATE_SYNC;
>> +                     break;
>> +             case V4L2_MBUS_VIDEO_COMPOSITE_SYNC:
>> +                     flags |= V4L2_MBUS_VIDEO_COMPOSITE_SYNC;
>> +                     break;
>> +             case V4L2_MBUS_VIDEO_SYNC_ON_COMPOSITE:
>> +                     flags |= V4L2_MBUS_VIDEO_SYNC_ON_COMPOSITE;
>> +                     break;
>> +             case V4L2_MBUS_VIDEO_SYNC_ON_GREEN:
>> +                     flags |= V4L2_MBUS_VIDEO_SYNC_ON_GREEN;
>> +                     break;
>> +             case V4L2_MBUS_VIDEO_SYNC_ON_LUMINANCE:
>> +                     flags |= V4L2_MBUS_VIDEO_SYNC_ON_LUMINANCE;
>> +                     break;
>> +             }
>> +     }
>> +
>>       bus->flags = flags;
>>
>>  }
>> diff --git a/include/dt-bindings/media/video-interfaces.h b/include/dt-bindings/media/video-interfaces.h
>> new file mode 100644
>> index 0000000..1a083dd
>> --- /dev/null
>> +++ b/include/dt-bindings/media/video-interfaces.h
>> @@ -0,0 +1,17 @@
>> +/*
>> + * This header provides constants for video interface.
>> + *
>> + */
>> +
>> +#ifndef _DT_BINDINGS_VIDEO_INTERFACES_H
>> +#define _DT_BINDINGS_VIDEO_INTERFACES_H
>> +
>> +#define V4L2_MBUS_VIDEO_SEPARATE_SYNC                (1 << 2)
>> +#define V4L2_MBUS_VIDEO_COMPOSITE_SYNC               (1 << 3)
>> +#define V4L2_MBUS_VIDEO_SYNC_ON_COMPOSITE    (1 << 4)
>
> What on earth is the difference between "COMPOSITE_SYNC" and "SYNC_ON_COMPOSITE"?!
>
Ahh my bad.

>> +#define V4L2_MBUS_VIDEO_SYNC_ON_GREEN                (1 << 5)
>> +#define V4L2_MBUS_VIDEO_SYNC_ON_LUMINANCE    (1 << 6)
>> +
>> +#define V4L2_MBUS_VIDEO_INTERFACES_END               6
>> +
>> +#endif
>
> Why would this be here? It isn't Device Tree specific, the same defines can
> be used without DT as well.
>
This is in here because we cannot include header files from other folder in
device tree files.

>> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
>> index 83ae07e..a4676dd 100644
>> --- a/include/media/v4l2-mediabus.h
>> +++ b/include/media/v4l2-mediabus.h
>> @@ -11,6 +11,8 @@
>>  #ifndef V4L2_MEDIABUS_H
>>  #define V4L2_MEDIABUS_H
>>
>> +#include <dt-bindings/media/video-interfaces.h>
>> +
>>  #include <linux/v4l2-mediabus.h>
>>
>>  /* Parallel flags */
>> @@ -28,18 +30,18 @@
>>   * V4L2_MBUS_[HV]SYNC* flags should be also used for specifying
>>   * configuration of hardware that uses [HV]REF signals
>>   */
>> -#define V4L2_MBUS_HSYNC_ACTIVE_HIGH          (1 << 2)
>> -#define V4L2_MBUS_HSYNC_ACTIVE_LOW           (1 << 3)
>> -#define V4L2_MBUS_VSYNC_ACTIVE_HIGH          (1 << 4)
>> -#define V4L2_MBUS_VSYNC_ACTIVE_LOW           (1 << 5)
>> -#define V4L2_MBUS_PCLK_SAMPLE_RISING         (1 << 6)
>> -#define V4L2_MBUS_PCLK_SAMPLE_FALLING                (1 << 7)
>> -#define V4L2_MBUS_DATA_ACTIVE_HIGH           (1 << 8)
>> -#define V4L2_MBUS_DATA_ACTIVE_LOW            (1 << 9)
>> +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH          (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 1))
>> +#define V4L2_MBUS_HSYNC_ACTIVE_LOW           (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 2))
>> +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH          (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 3))
>> +#define V4L2_MBUS_VSYNC_ACTIVE_LOW           (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 4))
>> +#define V4L2_MBUS_PCLK_SAMPLE_RISING         (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 5))
>> +#define V4L2_MBUS_PCLK_SAMPLE_FALLING                (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 6))
>> +#define V4L2_MBUS_DATA_ACTIVE_HIGH           (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 7))
>> +#define V4L2_MBUS_DATA_ACTIVE_LOW            (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 8))
>>  /* FIELD = 0/1 - Field1 (odd)/Field2 (even) */
>> -#define V4L2_MBUS_FIELD_EVEN_HIGH            (1 << 10)
>> +#define V4L2_MBUS_FIELD_EVEN_HIGH            (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 9))
>>  /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
>> -#define V4L2_MBUS_FIELD_EVEN_LOW             (1 << 11)
>> +#define V4L2_MBUS_FIELD_EVEN_LOW             (1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 10))
>
> And that would also do away with the ugly V4L2_MBUS_VIDEO_INTERFACES_END
> define. It's just asking for problems when some of the flags are defined
> in one header, and some in another header.
>
> I know it was discussed before, but I am uncomfortable with adding all these
> different sync types when the only one used in tvp7002 is SYNC_ON_GREEN.
>
> The only sync types I see in practice are Separate Sync (using separate H and V
> sync signals), Embedded Sync (using SAV/EAV codes) and in very rare cases
> Sync-on-Green. Sync-on-Luminance is I expect really identical to Sync-on-Green,
> only instead of using RGB it uses YUV where Y maps to the Green pin.
>
Laurent, Sylwester  what do you suggest ?

Regards,
--Prabhakar Lad
