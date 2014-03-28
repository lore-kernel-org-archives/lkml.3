Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaC1VqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:46:08 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:37869 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaC1VqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:46:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] [media] uvcvideo: Fix clock param realtime setting
Date: Fri, 28 Mar 2014 22:48:03 +0100
Message-ID: <2051908.tTlcvVaa3D@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396042028.3383.34.camel@Wailaba2>
References: <1395985358-17047-1-git-send-email-olivier@trillion01.com> <16236471.uFSjvbT2di@avalon> <1396042028.3383.34.camel@Wailaba2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olivier,

On Friday 28 March 2014 17:27:08 Olivier Langlois wrote:
> On Fri, 2014-03-28 at 17:20 +0100, Laurent Pinchart wrote:
> > On Friday 28 March 2014 01:42:38 Olivier Langlois wrote:
> > > timestamps in v4l2 buffers returned to userspace are updated in
> > > uvc_video_clock_update() which uses timestamps fetched from
> > > uvc_video_clock_decode() by calling unconditionally ktime_get_ts().
> > > 
> > > Hence setting the module clock param to realtime have no effect
> > > before this patch.
> > > 
> > > This has been tested with ffmpeg:
> > > 
> > > ffmpeg -y -f v4l2 -input_format yuyv422 -video_size 640x480 -framerate
> > > 30 -i /dev/video0 \ -f alsa -acodec pcm_s16le -ar 16000 -ac 1 -i
> > > default \
> > > -c:v libx264 -preset ultrafast \
> > > -c:a libfdk_aac \
> > > out.mkv
> > > 
> > > and inspecting the v4l2 input starting timestamp.
> > > 
> > > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > > Cc: Stable <stable@vger.kernel.org>
> > 
> > Before applying this, I'm curious, do you have a use case for realtime
> > time stamps ?
> 
> Yes. ffmpeg uses wall clock time to create timestamps for audio packets from
> ALSA device.

OK. I suppose I shouldn't drop support for the realtime clock like I wanted to 
then :-)
 
> There is a bug in ffmpeg describing problems to synchronize audio and
> the video from a v4l2 webcam.
> 
> https://trac.ffmpeg.org/ticket/692
> 
> To workaround this issue, ffmpeg devs added a switch to convert back
> monotonic to realtime. From ffmpeg/libavdevice/v4l2.c:
> 
>   -ts                <int>        .D.... set type of timestamps for
> grabbed frames (from 0 to 2) (default 0)
>      default                      .D.... use timestamps from the kernel
>      abs                          .D.... use absolute timestamps (wall
> clock)
>      mono2abs                     .D.... force conversion from monotonic
> to absolute timestamps
> 
> If the v4l2 driver is able to send realtime ts, it is easier synchronize
> in userspace if all inputs use the same clock.

That might be a stupid question, but shouldn't ALSA use the monotonic clock 
instead ?

-- 
Regards,

Laurent Pinchart

