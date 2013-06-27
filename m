Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3F0Gp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:45:56 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2759 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3F0Gpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:45:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 1/2] media: davinci: vpif: capture: add V4L2-async support
Date: Thu, 27 Jun 2013 08:45:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc6-tschai; KDE/4.9.5; x86_64; ; )
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1372173455-509-1-git-send-email-prabhakar.csengg@gmail.com> <201306270757.18109.hverkuil@xs4all.nl> <CA+V-a8s88k6XyjAZhKNNH5bG7BODyZqw=mA+__BTku5gmF8HEw@mail.gmail.com>
In-Reply-To: <CA+V-a8s88k6XyjAZhKNNH5bG7BODyZqw=mA+__BTku5gmF8HEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306270845.29043.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 27 2013 08:13:40 Prabhakar Lad wrote:
> Hi Hans,
> 
> Thanks for the review.
> 
> On Thu, Jun 27, 2013 at 11:27 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Tue June 25 2013 17:17:34 Prabhakar Lad wrote:
> >> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >>
> >> Add support for asynchronous subdevice probing, using the v4l2-async API.
> >> The legacy synchronous mode is still supported too, which allows to
> >> gradually update drivers and platforms.
> >>
> >> Signed-off-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
> >> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> >> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> ---
> >>  drivers/media/platform/davinci/vpif_capture.c |  151 +++++++++++++++++--------
> >>  drivers/media/platform/davinci/vpif_capture.h |    2 +
> >>  include/media/davinci/vpif_types.h            |    2 +
> >>  3 files changed, 107 insertions(+), 48 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> >> index 5514175..b11d7a7 100644
> >> --- a/drivers/media/platform/davinci/vpif_capture.c
> >> +++ b/drivers/media/platform/davinci/vpif_capture.c
> >> @@ -1979,6 +1979,76 @@ vpif_init_free_channel_objects:
> >>       return err;
> >>  }
> >>
> >> +static int vpif_async_bound(struct v4l2_async_notifier *notifier,
> >> +                         struct v4l2_subdev *subdev,
> >> +                         struct v4l2_async_subdev *asd)
> >> +{
> >> +     int i;
> >> +
> >> +     for (i = 0; i < vpif_obj.config->subdev_count; i++)
> >> +             if (!strcmp(vpif_obj.config->subdev_info[i].name,
> >> +                         subdev->name)) {
> >
> > Since the subdev name is now prefixed with the i2c bus identifier instead of
> > just the chip name, does this code still work? Shouldn't it be 'strstr' instead
> > of strcmp? Ditto for vpif_display and possibly others where the same
> > mechanism might be used.
> >
> This is because the DA850-EVM has two tvp514x devices and assigning
> the tvp514x device to appropriate channel is important, In this case strstr()
> wont work so I used strcmp instead to match it appropriately.
> 
> Yes the code still works tested on DA850-EVM, with this patch [1].
> 
> [1] http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git/commitdiff/c906a89762541361158cf73e9494fa2f1ff8ba02

Ah, OK. That's what I wanted to verify!

Regards,

	Hans

> 
> Regards,
> --Prabhakar Lad
> 
