Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaLQNMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:12:44 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:64105 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLQNMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:12:42 -0500
MIME-Version: 1.0
In-Reply-To: <5490469A.7010606@collabora.com>
References: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com>
 <548F272E.3040808@gmail.com> <548F2DD6.70805@collabora.com>
 <CAL8zT=jNis3VN11xN82fci5dA5f0TwAAhkBVq2+5TaKpmm_S-Q@mail.gmail.com>
 <1418736635.3374.64.camel@pengutronix.de> <54903E88.2070701@collabora.com>
 <CAL8zT=hq5mx71eB8dBea2qAuESjcLYremb81Vj-BjjTd+iA2-g@mail.gmail.com> <5490469A.7010606@collabora.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 17 Dec 2014 14:12:26 +0100
X-Google-Sender-Auth: xobcfyHV35f9FQvC6cUtHYozfdw
Message-ID: <CAL8zT=iFHpE6tZwkQTZ9W9H0L_F47PZv8X_AAmnV0u=A5Vk34w@mail.gmail.com>
Subject: Re: i.MX6 CSC and scaler
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBTdXJlYXU=?= <frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-16 15:50 GMT+01:00 Nicolas Dufresne <nicolas.dufresne@collabora.com>:
>
> Le 2014-12-16 09:27, Jean-Michel Hautbois a écrit :
>>
>> Have you already started something about that ?
>
> Yes, currently I do cropping right if there is no scaling. Doing this with
> S_CROP is really ackward, but very few m2m driver has been ported to
> G_SELECTION yet. The v4l2transform was tested to run with Exynos 4 FIMC
> driver. There was still issue with such driver doing middle rounding for
> alignment. This has been reported on this list. The proposed solution is to
> add flags to our internal alignment method, and update these driver to pick
> a direction.

Right now, I can get the driver probed (twice, as I have two IPUs) and
gstreamer creates two elements :
$> rm .cache/gstreamer-1.0/registry.arm.bin
$>
gst-inspect-1.0 |grep v4l2
video4linux2:  v4l2video3videodec: V4L2 Video Decoder
video4linux2:  v4l2video2h264enc: V4L2 H.264 Encoder
video4linux2:  v4l2video1convert: V4L2 Video Converter
video4linux2:  v4l2video0convert: V4L2 Video Converter
video4linux2:  v4l2deviceprovider (GstDeviceProviderFactory)
video4linux2:  v4l2radio: Radio (video4linux2) Tuner
video4linux2:  v4l2sink: Video (video4linux2) Sink
video4linux2:  v4l2src: Video (video4linux2) Source

$> gst-inspect-1.0 v4l2video0convert
Factory Details:
  Rank                     none (0)
  Long-name                V4L2 Video Converter
  Klass                    Filter/Converter/Video
  Description              Transform streams via V4L2 API
  Author                   Nicolas Dufresne <nicolas.dufresne@collabora.com>

Plugin Details:
  Name                     video4linux2
  Description              elements for Video 4 Linux
  Filename                 /usr/lib/gstreamer-1.0/libgstvideo4linux2.so
  Version                  1.5.0.1
  License                  LGPL
  Source module            gst-plugins-good
  Source release date      2014-12-15 11:41 (UTC)
  Binary package           GStreamer Good Plug-ins git
  Origin URL               Unknown package origin

GObject
 +----GInitiallyUnowned
       +----GstObject
             +----GstElement
                   +----GstBaseTransform
                         +----GstV4l2Transform
                               +----v4l2video0convert

Pad Templates:
  SINK template: 'sink'
    Availability: Always
    Capabilities:
      video/x-raw
                 format: { RGB16, RGB, BGR, xRGB, ARGB, BGRx, BGRA,
YUY2, UYVY, I420, YV12, NV12, NV21, Y42B }
                  width: [ 1, 32768 ]
                 height: [ 1, 32768 ]
              framerate: [ 0/1, 100/1 ]

  SRC template: 'src'
    Availability: Always
    Capabilities:
      video/x-raw
                 format: { RGB16, RGB, BGR, xRGB, ARGB, BGRx, BGRA,
YUY2, UYVY, I420, YV12, NV12, NV21, Y42B }
                  width: [ 1, 32768 ]
                 height: [ 1, 32768 ]
              framerate: [ 0/1, 100/1 ]


Element Flags:
  no flags set

Element Implementation:
  Has change_state() function: gst_v4l2_transform_change_state

Element has no clocking capabilities.
Element has no URI handling capabilities.

Pads:
  SINK: 'sink'
    Pad Template: 'sink'
  SRC: 'src'
    Pad Template: 'src'

Element Properties:
  name                : The name of the object
                        flags: readable, writable
                        String. Default: "v4l2video0convert0"
  parent              : The parent of the object
                        flags: readable, writable
                        Object of type "GstObject"
  qos                 : Handle Quality-of-Service events
                        flags: readable, writable
                        Boolean. Default: true
  device              : Device location
                        flags: readable
                        String. Default: "/dev/video0"
  device-name         : Name of the device
                        flags: readable
                        String. Default: "mx6-m2m"
  device-fd           : File descriptor of the device
                        flags: readable
                        Integer. Range: -1 - 2147483647 Default: -1
  output-io-mode      : Output side I/O mode (matches sink pad)
                        flags: readable, writable
                        Enum "GstV4l2IOMode" Default: 0, "auto"
                           (0): auto             - GST_V4L2_IO_AUTO
                           (1): rw               - GST_V4L2_IO_RW
                           (2): mmap             - GST_V4L2_IO_MMAP
                           (3): userptr          - GST_V4L2_IO_USERPTR
                           (4): dmabuf           - GST_V4L2_IO_DMABUF
                           (5): dmabuf-import    - GST_V4L2_IO_DMABUF_IMPORT
  capture-io-mode     : Capture I/O mode (matches src pad)
                        flags: readable, writable
                        Enum "GstV4l2IOMode" Default: 0, "auto"
                           (0): auto             - GST_V4L2_IO_AUTO
                           (1): rw               - GST_V4L2_IO_RW
                           (2): mmap             - GST_V4L2_IO_MMAP
                           (3): userptr          - GST_V4L2_IO_USERPTR
                           (4): dmabuf           - GST_V4L2_IO_DMABUF
                           (5): dmabuf-import    - GST_V4L2_IO_DMABUF_IMPORT
  extra-controls      : Extra v4l2 controls (CIDs) for the device
                        flags: readable, writable
                        Boxed pointer of type "GstStructure"


When I try to use it, the driver fails to work, because S_FMT needs to
be called first.
$> gst-launch-1.0 -vve videotestsrc !
'video/x-raw,format=YUY2,width=320,height=240' ! v4l2video0convert !
'video/x-raw,format=NV12,width=320,height=240' ! fakesink
Setting pipeline to PAUSED ...
Pipeline is PREROLLING ...
ERROR: from element
/GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0: Internal data
flow error.

$> dmesg
[10005.548047] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.555784] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.563482] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.571225] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.578925] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.586781] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.594583] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.602292] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.610125] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.617864] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.625559] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.633970] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.641730] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.649488] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.657217] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.664927] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.672629] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.680336] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.688070] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.695770] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.703457] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.711184] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.718880] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.727170] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.734885] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.742592] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.750301] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.758205] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.765910] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.773603] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.781334] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.789028] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.796743] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.804444] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.812141] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation
[10005.819862] mx6-m2m ipum2m@ipu1: call capture S_FMT first to
determine segmentation


So, basically it should be working because using v4l2-ctl I can do :
$> v4l2-ctl -d0 --set-fmt-video=width=320,height=240,pixelformat=5
--set-fmt-video-out=width=1920,height=1080,pixelformat=NV12
[10127.455820] mx6-m2m ipum2m@ipu1: Capture format: 320x240 (1 320x240
segments), YUYV
[10127.463584] mx6-m2m ipum2m@ipu1: Output format: 1920x1080 (1
1920x1080 segments), NV12

I may need some help in order to modify the gstreamer plugin now ;-).
JM
