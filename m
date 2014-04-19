Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaDSLl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:41:29 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51055 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaDSLlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:41:25 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 0/2] DaVinci: VPIF: upgrade with v4l helpers
Date: Sat, 19 Apr 2014 17:11:13 +0530
Message-Id: <1397907675-525-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Hi All,

This patch series upgrades the vpif capture & display
driver with the all the helpers provided by v4l, this makes
the driver much simpler and cleaner. This also includes few
checkpatch issues.

Sending them as single patch one for capture and another for
display, splitting them would have caused a huge number small
patches.

Changes for v2:
a> Added a copyright.
b> Dropped buf_init() callback from vb2_ops.
c> Fixed enabling & disabling of interrupts in case of HD formats.

Changes for v3:
a> Fixed review comments pointed by Hans.

v4l-compliance output is as follows:--

root@da850-omapl138-evm:/usr# ./v4l2-compliance -d /dev/video0 -i -s 
Driver Info:
        Driver name   : vpif_capture
        Card type     : DA850/OMAP-L13vpif_capture vpif_capture: =================  START STATUS  =================
vpif_capture vpif_capture: ==================  END STATUS  ==================

        Bus info      : platform:vpif_capture
        Driver version: 3.1.10
        Capabilities  : 0x84000001
                Video Capture
                Streaming
                Device Capabilities
        Device Caps   : 0x04000001
                Video Capture
                Streaming

Compliance test for device /dev/video0 (not using libv4l2):

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
        test VIDIOC_G/S_TUNER: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
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
                test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                fail: v4l2-test-formats.cpp(1003): cap->readbuffers
                test VIDIOC_G/S_PARM: FAIL
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: v4l2-test-formats.cpp(405): !pix.sizeimage
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                fail: v4l2-test-buffers.cpp(506): q.has_expbuf()
        test VIDIOC_EXPBUF: FAIL

Total: 38, Succeeded: 35, Failed: 3, Warnings: 0

For Display:---

root@da850-omapl138-evm:/usr# ./v4l2-compliance -d /dev/video2 -o -s 
Driver Info:
        Driver name   : vpif_display
        Card type     : DA850/OMAP-L138 Video Display
        Bus info      vpif_display vpif_display: =================  START STATUS  =================
: platform:vpif_display
        Driveradv7343 1-002a: Standard: ff
 version: 3.1.10adv7343 1-002a: Output: Composite

        Capabilities vpif_display vpif_display: ==================  END STATUS  ==================
 : 0x84000002
                Video Output
                Streaming
                Device Capabilities
        Device Caps   : 0x04000002
                Video Output
                Streaming

Compliance test for device /dev/video2 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
vpif_display vpif_display: Invalid format index
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK
vpif_display vpif_display: Invalid format index

Input ioctls:
        test VIDIOC_G/S_TUNER: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 2 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

Test output 0:

        Control ioctls:
                test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: v4l2-test-formats.cpp(406): !pix.colorspace
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Test output 1:

        Control ioctls:
                test VIDIOC_QUERYCTRL/MENU: OK (Not Supported)
                test VIDIOC_G/S_CTRL: OK (Not Supported)
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 0 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                fail: v4l2-test-formats.cpp(406): !pix.colorspace
                test VIDIOC_G_FMT: FAIL
                test VIDIOC_TRY_FMT: OK (Not Supported)
                test VIDIOC_S_FMT: OK (Not Supported)
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                fail: v4l2-test-buffers.cpp(506): q.has_expbuf()
        test VIDIOC_EXPBUF: FAIL

Total: 53, Succeeded: 50, Failed: 3, Warnings: 0


Lad, Prabhakar (2):
  media: davinci: vpif capture: upgrade the driver with v4l offerings
  media: davinci: vpif display: upgrade the driver with v4l offerings

 drivers/media/platform/davinci/vpif_capture.c | 1474 ++++++++-----------------
 drivers/media/platform/davinci/vpif_capture.h |   43 +-
 drivers/media/platform/davinci/vpif_display.c | 1257 +++++++--------------
 drivers/media/platform/davinci/vpif_display.h |   46 +-
 4 files changed, 844 insertions(+), 1976 deletions(-)

-- 
1.7.9.5

