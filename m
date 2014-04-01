Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaDANry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:47:54 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35376 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaDANrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:47:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] [media] uvcvideo: Fix clock param realtime setting
Date: Tue, 01 Apr 2014 15:49:54 +0200
Message-ID: <1711768.4zHOjaJUg6@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396153381.3383.66.camel@Wailaba2>
References: <1395985358-17047-1-git-send-email-olivier@trillion01.com> <2051908.tTlcvVaa3D@avalon> <1396153381.3383.66.camel@Wailaba2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olivier,

On Sunday 30 March 2014 00:23:01 Olivier Langlois wrote:
> Hi Laurent,
> 
> > > Yes. ffmpeg uses wall clock time to create timestamps for audio packets
> > > from ALSA device.
> > 
> > OK. I suppose I shouldn't drop support for the realtime clock like I
> > wanted to then :-)
> > 
> > > There is a bug in ffmpeg describing problems to synchronize audio and
> > > the video from a v4l2 webcam.
> > > 
> > > https://trac.ffmpeg.org/ticket/692
> > > 
> > > To workaround this issue, ffmpeg devs added a switch to convert back
> > > 
> > > monotonic to realtime. From ffmpeg/libavdevice/v4l2.c:
> > >   -ts                <int>        .D.... set type of timestamps for
> > >                                          grabbed frames (from 0 to 2)
> > >                                          (default 0)
> > >      default                      .D.... use timestamps from the kernel
> > >      abs                          .D.... use absolute timestamps (wall
> > >                                          clock)
> > >      mono2abs                     .D.... force conversion from monotonic
> > >                                          to absolute timestamps
> > > 
> > > If the v4l2 driver is able to send realtime ts, it is easier synchronize
> > > in userspace if all inputs use the same clock.
> > 
> > That might be a stupid question, but shouldn't ALSA use the monotonic
> > clock instead ?
> 
> I think that I have that answer why ffmpeg use realtime clock for ALSA data.
> In fact ffmpeg uses realtime clock for every data coming from capture
> devices and the purpose is to be able to seek into the recorded stream by
> using the date where the recording occured. Same principle than a camera
> recording dates when pictures are taken.
>
> now a tougher question is whether or not it is up to the driver to provide
> these realtime ts.

It makes sense to associate a wall time with recorded streams for that 
purpose, but synchronization should in my opinion be performed using the 
monotonic clock, as the wall time can jump around. I believe drivers should 
provide monotonic timestamps only. However, given that the uvcvideo driver has 
the option of providing wall clock timestamps, that option should work, so 
your patch makes sense. I'd still like to remove support for the wall clock 
though, but I don't want to break userspace. ffmpeg should be fixed, 
especially given that most V4L devices provide monotonic timestamps only.

-- 
Regards,

Laurent Pinchart

