Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbbAWTR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:17:26 -0500
Received: from lists.s-osg.org ([54.187.51.154]:54225 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbbAWTRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:17:21 -0500
Message-ID: <54C29E3E.7010009@osg.samsung.com>
Date: Fri, 23 Jan 2015 12:17:18 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: au0828 - convert to use videobuf2
References: <1421970125-8169-1-git-send-email-shuahkh@osg.samsung.com> <54C21952.7010602@xs4all.nl> <54C26204.9000106@osg.samsung.com>
In-Reply-To: <54C26204.9000106@osg.samsung.com>
Content-Type: multipart/mixed;
 boundary="------------080007060500050000060901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080007060500050000060901
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 01/23/2015 08:00 AM, Shuah Khan wrote:
> On 01/23/2015 02:50 AM, Hans Verkuil wrote:
>> Hi Shuah,
>>
>> On 01/23/2015 12:42 AM, Shuah Khan wrote:
>>> Convert au0828 to use videobuf2. Tested with NTSC.
>>> Tested video and vbi devices with xawtv, tvtime,
>>> and vlc. Ran v4l2-compliance to ensure there are
>>> no regressions. video now has no failures and vbi
>>> has 3 fewer failures.
>>>
>>> video before:
>>> test VIDIOC_G_FMT: FAIL 3 failures
>>> Total: 72, Succeeded: 69, Failed: 3, Warnings: 0
>>>
>>> Video after:
>>> Total: 72, Succeeded: 72, Failed: 0, Warnings: 18
>>>
>>> vbi before:
>>>     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>>>     test VIDIOC_EXPBUF: FAIL
>>>     test USERPTR: FAIL
>>>     Total: 72, Succeeded: 66, Failed: 6, Warnings: 0
>>>
>>> vbi after:
>>>     test VIDIOC_QUERYCAP: FAIL
>>>     test MMAP: FAIL
>>>     Total: 78, Succeeded: 75, Failed: 3, Warnings: 0
>>
>> There shouldn't be any fails for VBI. That really needs to be fixed.
>> Esp. the QUERYCAP fail should be easy to fix.
>>
>> BTW, can you paste the full v4l2-compliance output next time? That's
>> more informative than just these summaries.
>>
> 
> I will re-run the tests and fix it and resend the patch. I think I was
> seeing querycap compliance failure when run with -V0 option and not when
> I run it without. I can attach the full log.
> 

Hi Hans,

Finally some sanity. When I ran the compliance test on vbi device
with incorrect options, hence it was treated as a video device which
explains the following fail message:
fail: v4l2-compliance.cpp(347): node->is_video && !(dcaps & video_caps)
	test VIDIOC_QUERYCAP: FAIL

This is my bad - I must have did command recall and just changed the
device file. Sorry for the confusion.

Re-ran the test correctly this time and I don't see any querycap errors.
Please see attached files for vbi and video. I will resend the patch
with updated change log with the correct results.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

--------------080007060500050000060901
Content-Type: text/plain; charset=UTF-8;
 name="vbi_compliance.out"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="vbi_compliance.out"

Driver Info:
	Driver name   : au0828
	Card type     : Hauppauge HVR950Q
	Bus info      : usb-0000:00:10.1-2
	Driver version: 3.19.0
	Capabilities  : 0x85230011
		Video Capture
		VBI Capture
		Tuner
		Audio
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x05230010
		VBI Capture
		Tuner
		Audio
		Read/Write
		Streaming
		Extended Pix Format

Compliance test for device /dev/vbi0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second vbi open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK
	Inputs: 3 Audio Inputs: 2 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 1:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 2:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK


Total: 75, Succeeded: 75, Failed: 0, Warnings: 0

--------------080007060500050000060901
Content-Type: text/plain; charset=UTF-8;
 name="video_compliance.out"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="video_compliance.out"

Driver Info:
	Driver name   : au0828
	Card type     : Hauppauge HVR950Q
	Bus info      : usb-0000:00:10.1-2
	Driver version: 3.19.0
	Capabilities  : 0x85230011
		Video Capture
		VBI Capture
		Tuner
		Audio
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x05230001
		Video Capture
		Tuner
		Audio
		Read/Write
		Streaming
		Extended Pix Format

Compliance test for device /dev/video1 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK
	Inputs: 3 Audio Inputs: 2 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(691): TRY_FMT cannot handle an invalid pixe=
lformat.
		warn: v4l2-test-formats.cpp(692): This may or may not be a problem. For=
 more information see:
		warn: v4l2-test-formats.cpp(693): http://www.mail-archive.com/linux-med=
ia@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(907): S_FMT cannot handle an invalid pixelf=
ormat.
		warn: v4l2-test-formats.cpp(908): This may or may not be a problem. For=
 more information see:
		warn: v4l2-test-formats.cpp(909): http://www.mail-archive.com/linux-med=
ia@vger.kernel.org/msg56550.html
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 1:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(691): TRY_FMT cannot handle an invalid pixe=
lformat.
		warn: v4l2-test-formats.cpp(692): This may or may not be a problem. For=
 more information see:
		warn: v4l2-test-formats.cpp(693): http://www.mail-archive.com/linux-med=
ia@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(907): S_FMT cannot handle an invalid pixelf=
ormat.
		warn: v4l2-test-formats.cpp(908): This may or may not be a problem. For=
 more information see:
		warn: v4l2-test-formats.cpp(909): http://www.mail-archive.com/linux-med=
ia@vger.kernel.org/msg56550.html
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK

Test input 2:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(691): TRY_FMT cannot handle an invalid pixe=
lformat.
		warn: v4l2-test-formats.cpp(692): This may or may not be a problem. For=
 more information see:
		warn: v4l2-test-formats.cpp(693): http://www.mail-archive.com/linux-med=
ia@vger.kernel.org/msg56550.html
		test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(907): S_FMT cannot handle an invalid pixelf=
ormat.
		warn: v4l2-test-formats.cpp(908): This may or may not be a problem. For=
 more information see:
		warn: v4l2-test-formats.cpp(909): http://www.mail-archive.com/linux-med=
ia@vger.kernel.org/msg56550.html
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK


Total: 75, Succeeded: 75, Failed: 0, Warnings: 18

--------------080007060500050000060901--
