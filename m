Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbbAOKxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:53:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbbAOKxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:53:37 -0500
Message-ID: <54B79C0E.4080903@redhat.com>
Date: Thu, 15 Jan 2015 11:53:02 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>, Joe Howse <josephhowse@nummist.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] gspca: Add high-speed modes for PS3 Eye camera
References: <1419865203-3967-1-git-send-email-josephhowse@nummist.com> <20150104162909.f29952436894222f8074862f@ao2.it>
In-Reply-To: <20150104162909.f29952436894222f8074862f@ao2.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04-01-15 16:29, Antonio Ospite wrote:
> On Mon, 29 Dec 2014 11:00:03 -0400
> Joe Howse <josephhowse@nummist.com> wrote:
>
>> Add support in the PS3 Eye driver for QVGA capture at higher
>> frame rates: 187, 150, and 137 FPS. This functionality is valuable
>> because the PS3 Eye is popular for computer vision projects and no
>> other camera in its price range supports such high frame rates.
>>
>> Correct a QVGA mode that was listed as 40 FPS. It is really 37 FPS
>> (half of 75 FPS).
>>
>> Tests confirm that the nominal frame rates are achieved.
>>
>> Signed-off-by: Joe Howse <josephhowse@nummist.com>
>
> Tested-by: Antonio Ospite <ao2@ao2.it>

Joe, thanks for the patch, Antonio, thanks for testing, I've queued
this up in my gspca tree for merging into the 3.20 kernel

Regards,

Hans

>
> Thanks Joe.
>
> I noticed that qv4l2 displays max 60fps even though from the video I can
> perceive the higher framerate, and same happens in guvcview.
>
> gst-inspect-1.0 won't even let me set framerates higher than 75 so
> I didn't test with GStreamer.
>
> I know that the camera is also able to stream raw Bayer data which
> requires less bandwidth than the default YUYV, although the driver does
> not currently expose that; maybe some higher framerates can be achieved
> also at VGA with Bayer output.
>
> In case you wanted to explore that remember to set supported framerates
> appropriately in ov772x_framerates for the 4 combinations of formats and
> resolutions (i.e. Bayer outputs will support more framerates).
>
> Ciao,
>     Antonio
>
>> ---
>>   drivers/media/usb/gspca/ov534.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
>> index 90f0d63..a9c866d 100644
>> --- a/drivers/media/usb/gspca/ov534.c
>> +++ b/drivers/media/usb/gspca/ov534.c
>> @@ -12,6 +12,8 @@
>>    * PS3 Eye camera enhanced by Richard Kaswy http://kaswy.free.fr
>>    * PS3 Eye camera - brightness, contrast, awb, agc, aec controls
>>    *                  added by Max Thrun <bear24rw@gmail.com>
>> + * PS3 Eye camera - FPS range extended by Joseph Howse
>> + *                  <josephhowse@nummist.com> http://nummist.com
>>    *
>>    * This program is free software; you can redistribute it and/or modify
>>    * it under the terms of the GNU General Public License as published by
>> @@ -116,7 +118,7 @@ static const struct v4l2_pix_format ov767x_mode[] = {
>>   		.colorspace = V4L2_COLORSPACE_JPEG},
>>   };
>>
>> -static const u8 qvga_rates[] = {125, 100, 75, 60, 50, 40, 30};
>> +static const u8 qvga_rates[] = {187, 150, 137, 125, 100, 75, 60, 50, 37, 30};
>>   static const u8 vga_rates[] = {60, 50, 40, 30, 15};
>>
>>   static const struct framerates ov772x_framerates[] = {
>> @@ -769,12 +771,16 @@ static void set_frame_rate(struct gspca_dev *gspca_dev)
>>   		{15, 0x03, 0x41, 0x04},
>>   	};
>>   	static const struct rate_s rate_1[] = {	/* 320x240 */
>> +/*		{205, 0x01, 0xc1, 0x02},  * 205 FPS: video is partly corrupt */
>> +		{187, 0x01, 0x81, 0x02}, /* 187 FPS or below: video is valid */
>> +		{150, 0x01, 0xc1, 0x04},
>> +		{137, 0x02, 0xc1, 0x02},
>>   		{125, 0x02, 0x81, 0x02},
>>   		{100, 0x02, 0xc1, 0x04},
>>   		{75, 0x03, 0xc1, 0x04},
>>   		{60, 0x04, 0xc1, 0x04},
>>   		{50, 0x02, 0x41, 0x04},
>> -		{40, 0x03, 0x41, 0x04},
>> +		{37, 0x03, 0x41, 0x04},
>>   		{30, 0x04, 0x41, 0x04},
>>   	};
>>
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
