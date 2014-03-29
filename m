Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaC2C5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 22:57:37 -0400
Received: from oproxy9-pub.mail.unifiedlayer.com ([69.89.24.6]:42692 "HELO
	oproxy9-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751507AbaC2C5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 22:57:35 -0400
Message-ID: <1396061452.3383.42.camel@Wailaba2>
Subject: Re: [PATCH] [media] uvcvideo: Fix clock param realtime setting
From: Olivier Langlois <olivier@trillion01.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Date: Fri, 28 Mar 2014 22:50:52 -0400
In-Reply-To: <2051908.tTlcvVaa3D@avalon>
References: <1395985358-17047-1-git-send-email-olivier@trillion01.com>
	 <16236471.uFSjvbT2di@avalon> <1396042028.3383.34.camel@Wailaba2>
	 <2051908.tTlcvVaa3D@avalon>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.179.63.169 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > 
> > > Before applying this, I'm curious, do you have a use case for realtime
> > > time stamps ?
> > 
> > Yes. ffmpeg uses wall clock time to create timestamps for audio packets from
> > ALSA device.
> 
> OK. I suppose I shouldn't drop support for the realtime clock like I wanted to 
> then :-)
>  
> > There is a bug in ffmpeg describing problems to synchronize audio and
> > the video from a v4l2 webcam.
> > 
> > https://trac.ffmpeg.org/ticket/692
> > 
> > To workaround this issue, ffmpeg devs added a switch to convert back
> > monotonic to realtime. From ffmpeg/libavdevice/v4l2.c:
> > 
> >   -ts                <int>        .D.... set type of timestamps for
> > grabbed frames (from 0 to 2) (default 0)
> >      default                      .D.... use timestamps from the kernel
> >      abs                          .D.... use absolute timestamps (wall
> > clock)
> >      mono2abs                     .D.... force conversion from monotonic
> > to absolute timestamps
> > 
> > If the v4l2 driver is able to send realtime ts, it is easier synchronize
> > in userspace if all inputs use the same clock.
> 
> That might be a stupid question, but shouldn't ALSA use the monotonic clock 
> instead ?
> 

This isn't stupid. I had the same though after replying you.
Intuitively, I would think that monotonic clock is a better choice for
multimedia. I am just speculating but I would say that ffmpeg decided to
use realtime clock as the standard clock throughout the project for
portability purposes since it is a cross-platform project.

Now you know how I ended up trying the clock=realtime option.
IMHO, if the option is there, it should be working but just removing it
could also be a valid option.

I feel that this could bring some new problems if it stays there
because, I'll be honest and say that I didn't test the driver behavior
when the time goes backward....



