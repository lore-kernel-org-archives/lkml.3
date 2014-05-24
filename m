Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbaEXE17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 00:27:59 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47839 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXE15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 00:27:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140523193822.3c097380.m.chehab@samsung.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
 <1400247235-31434-44-git-send-email-prabhakar.csengg@gmail.com> <20140523193822.3c097380.m.chehab@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 24 May 2014 09:57:25 +0530
Message-ID: <CA+V-a8tR1fnbjm-6Og9ZyEEhV0WKG+wd2TfG0LkzE8k9rtU1Rw@mail.gmail.com>
Subject: Re: [PATCH v5 41/49] media: davinci: vpif_capture: drop unneeded
 module params
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Sat, May 24, 2014 at 4:08 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Fri, 16 May 2014 19:03:47 +0530
> "Lad, Prabhakar" <prabhakar.csengg@gmail.com> escreveu:
>
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> -ENOPATCHDESCRIPTION!!!!
>
> Why to remove those parameters? Please _ALWAYS_ describe your patches.
>
My bad! will take care next time.

Thanks,
--Prabhakar Lad

> My crystal ball is malfunctioning today, so I was unable to scry the
> reasons for this patch.
>
> Thanks,
> Mauro
>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c |   54 +------------------------
>>  drivers/media/platform/davinci/vpif_capture.h |   11 -----
>>  2 files changed, 1 insertion(+), 64 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index d452eaf..e967cf7 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -38,32 +38,10 @@ MODULE_VERSION(VPIF_CAPTURE_VERSION);
>>               v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
>>
>>  static int debug = 1;
>> -static u32 ch0_numbuffers = 3;
>> -static u32 ch1_numbuffers = 3;
>> -static u32 ch0_bufsize = 1920 * 1080 * 2;
>> -static u32 ch1_bufsize = 720 * 576 * 2;
>>
>>  module_param(debug, int, 0644);
>> -module_param(ch0_numbuffers, uint, S_IRUGO);
>> -module_param(ch1_numbuffers, uint, S_IRUGO);
>> -module_param(ch0_bufsize, uint, S_IRUGO);
>> -module_param(ch1_bufsize, uint, S_IRUGO);
>>
>>  MODULE_PARM_DESC(debug, "Debug level 0-1");
>> -MODULE_PARM_DESC(ch2_numbuffers, "Channel0 buffer count (default:3)");
>> -MODULE_PARM_DESC(ch3_numbuffers, "Channel1 buffer count (default:3)");
>> -MODULE_PARM_DESC(ch2_bufsize, "Channel0 buffer size (default:1920 x 1080 x 2)");
>> -MODULE_PARM_DESC(ch3_bufsize, "Channel1 buffer size (default:720 x 576 x 2)");
>> -
>> -static struct vpif_config_params config_params = {
>> -     .min_numbuffers = 3,
>> -     .numbuffers[0] = 3,
>> -     .numbuffers[1] = 3,
>> -     .min_bufsize[0] = 720 * 480 * 2,
>> -     .min_bufsize[1] = 720 * 480 * 2,
>> -     .channel_bufsize[0] = 1920 * 1080 * 2,
>> -     .channel_bufsize[1] = 720 * 576 * 2,
>> -};
>>
>>  #define VPIF_DRIVER_NAME     "vpif_capture"
>>
>> @@ -609,9 +587,6 @@ static void vpif_config_format(struct channel_obj *ch)
>>       vpif_dbg(2, debug, "vpif_config_format\n");
>>
>>       common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
>> -     common->fmt.fmt.pix.sizeimage
>> -         = config_params.channel_bufsize[ch->channel_id];
>> -
>>       if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER)
>>               common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
>>       else
>> @@ -1358,36 +1333,9 @@ static struct v4l2_file_operations vpif_fops = {
>>   */
>>  static int initialize_vpif(void)
>>  {
>> -     int err = 0, i, j;
>> +     int err, i, j;
>>       int free_channel_objects_index;
>>
>> -     /* Default number of buffers should be 3 */
>> -     if ((ch0_numbuffers > 0) &&
>> -         (ch0_numbuffers < config_params.min_numbuffers))
>> -             ch0_numbuffers = config_params.min_numbuffers;
>> -     if ((ch1_numbuffers > 0) &&
>> -         (ch1_numbuffers < config_params.min_numbuffers))
>> -             ch1_numbuffers = config_params.min_numbuffers;
>> -
>> -     /* Set buffer size to min buffers size if it is invalid */
>> -     if (ch0_bufsize < config_params.min_bufsize[VPIF_CHANNEL0_VIDEO])
>> -             ch0_bufsize =
>> -                 config_params.min_bufsize[VPIF_CHANNEL0_VIDEO];
>> -     if (ch1_bufsize < config_params.min_bufsize[VPIF_CHANNEL1_VIDEO])
>> -             ch1_bufsize =
>> -                 config_params.min_bufsize[VPIF_CHANNEL1_VIDEO];
>> -
>> -     config_params.numbuffers[VPIF_CHANNEL0_VIDEO] = ch0_numbuffers;
>> -     config_params.numbuffers[VPIF_CHANNEL1_VIDEO] = ch1_numbuffers;
>> -     if (ch0_numbuffers) {
>> -             config_params.channel_bufsize[VPIF_CHANNEL0_VIDEO]
>> -                 = ch0_bufsize;
>> -     }
>> -     if (ch1_numbuffers) {
>> -             config_params.channel_bufsize[VPIF_CHANNEL1_VIDEO]
>> -                 = ch1_bufsize;
>> -     }
>> -
>>       /* Allocate memory for six channel objects */
>>       for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>>               vpif_obj.dev[i] =
>> diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
>> index 4960504..537076a 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.h
>> +++ b/drivers/media/platform/davinci/vpif_capture.h
>> @@ -125,16 +125,5 @@ struct vpif_device {
>>       struct vpif_capture_config *config;
>>  };
>>
>> -struct vpif_config_params {
>> -     u8 min_numbuffers;
>> -     u8 numbuffers[VPIF_CAPTURE_NUM_CHANNELS];
>> -     s8 device_type;
>> -     u32 min_bufsize[VPIF_CAPTURE_NUM_CHANNELS];
>> -     u32 channel_bufsize[VPIF_CAPTURE_NUM_CHANNELS];
>> -     u8 default_device[VPIF_CAPTURE_NUM_CHANNELS];
>> -     u32 video_limit[VPIF_CAPTURE_NUM_CHANNELS];
>> -     u8 max_device_type;
>> -};
>> -
>>  #endif                               /* End of __KERNEL__ */
>>  #endif                               /* VPIF_CAPTURE_H */
