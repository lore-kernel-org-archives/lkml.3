Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaDBE1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 00:27:22 -0400
Received: from gproxy3-pub.mail.unifiedlayer.com ([69.89.30.42]:58976 "HELO
	gproxy3-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751552AbaDBE1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 00:27:20 -0400
X-Authority-Analysis: v=2.1 cv=ZpR+dbLG c=1 sm=1 tr=0
 a=RxOGq9YxerWOMOBYTEp+bA==:117 a=RxOGq9YxerWOMOBYTEp+bA==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=8Ta_JQFhb8AA:10 a=bbmU6RERmxsA:10 a=8nJEP1OIZ-IA:10
 a=Guo9nE61AAAA:8 a=lM4n3qrjNgMA:10 a=emhf11hzAAAA:8 a=pgNxlGAFGiNpb-XTzfcA:9
 a=wPNLvfGTeEIA:10
Message-ID: <1396412820.3383.111.camel@Wailaba2>
Subject: Re: [PATCH] [media] uvcvideo: Fix clock param realtime setting
From: Olivier Langlois <olivier@trillion01.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        ffmpeg-devel@ffmpeg.com
Date: Wed, 02 Apr 2014 00:27:00 -0400
In-Reply-To: <1711768.4zHOjaJUg6@avalon>
References: <1395985358-17047-1-git-send-email-olivier@trillion01.com>
	 <2051908.tTlcvVaa3D@avalon> <1396153381.3383.66.camel@Wailaba2>
	 <1711768.4zHOjaJUg6@avalon>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.179.63.169 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, 2014-04-01 at 15:49 +0200, Laurent Pinchart wrote:
> Hi Olivier,
> 
> On Sunday 30 March 2014 00:23:01 Olivier Langlois wrote:
> > Hi Laurent,
> > 
> > > > Yes. ffmpeg uses wall clock time to create timestamps for audio packets
> > > > from ALSA device.
> > > 
> > > OK. I suppose I shouldn't drop support for the realtime clock like I
> > > wanted to then :-)
> > > 
> > > > There is a bug in ffmpeg describing problems to synchronize audio and
> > > > the video from a v4l2 webcam.
> > > > 
> > > > https://trac.ffmpeg.org/ticket/692
> > > > 
> > > > To workaround this issue, ffmpeg devs added a switch to convert back
> > > > 
> > > > monotonic to realtime. From ffmpeg/libavdevice/v4l2.c:
> > > >   -ts                <int>        .D.... set type of timestamps for
> > > >                                          grabbed frames (from 0 to 2)
> > > >                                          (default 0)
> > > >      default                      .D.... use timestamps from the kernel
> > > >      abs                          .D.... use absolute timestamps (wall
> > > >                                          clock)
> > > >      mono2abs                     .D.... force conversion from monotonic
> > > >                                          to absolute timestamps
> > > > 
> > > > If the v4l2 driver is able to send realtime ts, it is easier synchronize
> > > > in userspace if all inputs use the same clock.
> > > 
> > > That might be a stupid question, but shouldn't ALSA use the monotonic
> > > clock instead ?
> > 
> > I think that I have that answer why ffmpeg use realtime clock for ALSA data.
> > In fact ffmpeg uses realtime clock for every data coming from capture
> > devices and the purpose is to be able to seek into the recorded stream by
> > using the date where the recording occured. Same principle than a camera
> > recording dates when pictures are taken.
> >
> > now a tougher question is whether or not it is up to the driver to provide
> > these realtime ts.
> 
> It makes sense to associate a wall time with recorded streams for that 
> purpose, but synchronization should in my opinion be performed using the 
> monotonic clock, as the wall time can jump around. I believe drivers should 
> provide monotonic timestamps only. However, given that the uvcvideo driver has 
> the option of providing wall clock timestamps, that option should work, so 
> your patch makes sense. I'd still like to remove support for the wall clock 
> though, but I don't want to break userspace. ffmpeg should be fixed, 
> especially given that most V4L devices provide monotonic timestamps only.
> 
Please do not stop yourself to remove realtime ts support in your driver
because that would not break ffmpeg, IMHO. It is just me that have tried
to leverage options offered by your driver to remove the need to use
ffmpeg workaround for a sync issue. I apparently have been the first
ffmpeg user to try out!

I am currently in the process to contribute the introduction of using
CLOCK_MONOTONIC inside ffmpeg. CCing their list because I think your
reply is relevant to the discussion we have on the topic there at the
moment.

thank you,
Olivier


