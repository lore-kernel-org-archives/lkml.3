Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3CTLGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:06:19 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:47400 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752093Ab3CTLGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:06:17 -0400
Date: Wed, 20 Mar 2013 12:09:30 +0100
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        elezegarcia@gmail.com
Subject: Re: [RFC V1 4/8] smi2021: Add smi2021_v4l2.c
Message-ID: <20130320110930.GP17291@dell.arpanet.local>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
 <201303201110.57579.hverkuil@xs4all.nl>
 <20130320101626.GO17291@dell.arpanet.local>
 <201303201121.48178.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303201121.48178.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:21:48AM +0100, Hans Verkuil wrote:
> On Wed 20 March 2013 11:16:26 Jon Arne Jørgensen wrote:
> > On Wed, Mar 20, 2013 at 11:10:57AM +0100, Hans Verkuil wrote:
> > > On Wed 20 March 2013 10:48:42 Jon Arne Jørgensen wrote:
> > > > On Mon, Mar 18, 2013 at 09:29:07AM +0100, Hans Verkuil wrote:
> > > > > On Thu March 14 2013 15:07:00 Jon Arne Jørgensen wrote:
> > > > > > This file is responsible for registering the device with the v4l2 subsystem,
> > > > > > and the communication with v4l2.
> > > > > > Most of the v4l2 ioctls are just passed on to vidbuf2.
> > > > > > 
> > > > > > Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> > > > > > ---
> > > > > >  drivers/media/usb/smi2021/smi2021_v4l2.c | 566 +++++++++++++++++++++++++++++++
> > > > > >  1 file changed, 566 insertions(+)
> > > > > >  create mode 100644 drivers/media/usb/smi2021/smi2021_v4l2.c
> > > > > > 
> > > > > > diff --git a/drivers/media/usb/smi2021/smi2021_v4l2.c b/drivers/media/usb/smi2021/smi2021_v4l2.c
> > > > > > new file mode 100644
> > > > > > index 0000000..d402093
> > > > > > --- /dev/null
> > > > > > +++ b/drivers/media/usb/smi2021/smi2021_v4l2.c
> > > > > > @@ -0,0 +1,566 @@
> > > > > 
> > > > > ...
> > > > > 
> > > > > > +int smi2021_vb2_setup(struct smi2021_dev *dev)
> > > > > > +{
> > > > > > +	int rc;
> > > > > > +	struct vb2_queue *q;
> > > > > > +
> > > > > > +	q = &dev->vb_vidq;
> > > > > > +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > > > > > +	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
> > > > > > +	q->drv_priv = dev;
> > > > > > +	q->buf_struct_size = sizeof(struct smi2021_buffer);
> > > > > > +	q->ops = &smi2021_video_qops;
> > > > > > +	q->mem_ops = &vb2_vmalloc_memops;
> > > > > 
> > > > > q->timestamp_type isn't filled in.
> > > > >
> > > > I'll add that
> > > >  
> > > > > For that matter, neither the sequence number nor the timestamp are filled in
> > > > > in v4l2_buffer during capturing.
> > > > > 
> > > > > You need to add a buf_finish op to fill those in (use v4l2_timestamp() for the
> > > > > timestamp).
> > > > >
> > > > 
> > > > I'm filling these variables in the smi2021_buffer_done function in
> > > > smi2021_video.c?
> > > 
> > > Ah, I missed that. Sorry about that.
> > > 
> > > Just replace gettimeofday with v4l2_timestamp(), though. We no longer use
> > > gettimeofday() in new drivers, but instead we use the monotonic clock.
> > > 
> > 
> > No problem,
> > I'll fix this.
> 
> BTW, I've tried your driver with my somagic USB device, but it doesn't work
> for me. I get -71 errors on the USB bus. I do seem to have all the right chips
> including the gm7113 (saa7113 replacement).
> 
> I need to double-check under Windows whether it is really working...

Hm, I sometimes get two of these errors when starting a capture, but
after that my device keeps running smoothly.

If you have time, can you please also test your device with the userspace
(libusb) tool for the somagic devices.

You'll find it here:
http://code.google.com/p/easycap-somagic-linux/

> 
> Regards,
> 
> 	Hans
