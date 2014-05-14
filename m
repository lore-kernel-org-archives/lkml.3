Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaENR3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:29:22 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:39501 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaENR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <5370997C.1060700@xs4all.nl>
References: <1399885110-9899-1-git-send-email-prabhakar.csengg@gmail.com>
 <1399885110-9899-2-git-send-email-prabhakar.csengg@gmail.com> <5370997C.1060700@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 14 May 2014 22:58:48 +0530
Message-ID: <CA+V-a8vMtY32gMy6BWvewL1jafEKuuL5U_J8+BbFfWWsZn0hqg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] media: davinci: vpif capture: upgrade the driver
 with v4l offerings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Mon, May 12, 2014 at 3:20 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> Thanks for the patch, but I have a few comments...
>
> On 05/12/2014 10:58 AM, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch upgrades the vpif display driver with
>> v4l helpers, this patch does the following,
>>
>> 1: initialize the vb2 queue and context at the time of probe
>> and removes context at remove() callback.
>> 2: uses vb2_ioctl_*() helpers.
>> 3: uses vb2_fop_*() helpers.
>> 4: uses SIMPLE_DEV_PM_OPS.
>> 5: uses vb2_ioctl_*() helpers.
>> 6: vidioc_g/s_priority is now handled by v4l core.
>> 7: removed driver specific fh and now using one provided by v4l.
>> 8: fixes checkpatch warnings.
>
> This really packs too much in one patch. At the very least 1, 4, 6 and
> 8 can be done in separate patches. 2 and 5 are duplicates, BTW. The way
> it is now makes this hard to review. So it would be much appreciated if
> you can split it up.
>
Ok, I have started working on splitting them up.

>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>
>> root@da850-omapl138-evm:/usr# ./v4l2-compliance -d /dev/video0 -i -s -v
>> Driver Info:
>>         Driver name   : vpif_capture
>> vpif_capture vpif_capture: =================  START STATUS  =================
>>
>>         Bus info      : platform:vpif_capture
>>         Drivervpif_capture vpif_capture: ==================  END STATUS  ==================
>>  version: 3.15.0
>>         Capabilities  : 0x84000001
>>                 Video Capture
>>                 Streaming
>>                 Device Capabilities
>>         Device Caps   : 0x04000001
>>                 Video Capture
>>                 Streaming
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>         test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>         test second video open: OK
>>         test VIDIOC_QUERYCAP: OK
>>         test VIDIOC_G/S_PRIORITY: OK
>>
>> Debug ioctls:
>>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>         test VIDIOC_LOG_STATUS: OK
>>
>> Input ioctls:
>>         test VIDIOC_G/S_TUNER: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMINPUT: OK
>>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>         Inputs: 1 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>         Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>         test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>> Test input 0:
>>
>>         Control ioctls:
>>                 test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
>>                 test VIDIOC_G/S_CTRL: OK (Not Supported)
>>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>                 Standard Controls: 0 Private Controls: 0
>>
>>         Format ioctls:
>>                 info: found 1 formats for buftype 1
>>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>                 fail: v4l2-test-formats.cpp(1003): cap->readbuffers
>
> Just set readbuffers to the minimum number of buffers that queue_setup uses.
>

OK.

>>                 test VIDIOC_G/S_PARM: FAIL
>>                 test VIDIOC_G_FBUF: OK (Not Supported)
>>                 fail: v4l2-test-formats.cpp(405): !pix.sizeimage
>
> Highly dubious. You need to investigate this!
>
Fixed it.

>>                 test VIDIOC_G_FMT: FAIL
>>                 test VIDIOC_TRY_FMT: OK (Not Supported)
>>                 test VIDIOC_S_FMT: OK (Not Supported)
>>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>
>>         Codec ioctls:
>>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>> Buffer ioctls:
>>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>                 fail: v4l2-test-buffers.cpp(506): q.has_expbuf()
>
> This is weird. I'm not sure why this happens since you seem to have VB2_DMABUF set
> and also vb2_ioctl_expbuf.
>
>>         test VIDIOC_EXPBUF: FAIL
>>
>> Total: 38, Succeeded: 35, Failed: 3, Warnings: 0
>
> Also test with 'v4l2-compliance -s' (streaming). The '-i' option is available to
> test streaming from a specific input.
>
BTW the output is with -s option set.

Thanks,
--Prabhakar Lad
