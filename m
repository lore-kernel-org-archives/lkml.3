Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3ALRok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:44:40 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52039 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3ALRoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:44:39 -0500
MIME-Version: 1.0
In-Reply-To: <1615162.CJ0Ejj80il@avalon>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+VQKxu7_-=aJeW-FxmM4fdVX1nBE7AA5-0d9SRgRqqM1g@mail.gmail.com>
	<20121227214937.6276e2a3@redhat.com>
	<1615162.CJ0Ejj80il@avalon>
Date: Sat, 12 Jan 2013 14:44:38 -0300
Message-ID: <CALF0-+WigCJULSdSzSKNUbNJ2S_v=jN1h7t3xZTp7NwxZjL09w@mail.gmail.com>
Subject: Re: [PATCH 01/23] uvc: Replace memcpy with struct assignment
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Julia.Lawall@lip6.fr,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 9:19 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Ezequiel,
>
> On Thursday 27 December 2012 21:49:37 Mauro Carvalho Chehab wrote:
>> Em Thu, 27 Dec 2012 18:12:46 -0300 Ezequiel Garcia escreveu:
>> > On Tue, Oct 23, 2012 at 4:57 PM, Ezequiel Garcia wrote:
>> > > This kind of memcpy() is error-prone. Its replacement with a struct
>> > > assignment is prefered because it's type-safe and much easier to read.
>> > >
>> > > Found by coccinelle. Hand patched and reviewed.
>> > > Tested by compilation only.
>> > >
>> > > A simplified version of the semantic match that finds this problem is as
>> > > follows: (http://coccinelle.lip6.fr/)
>> > >
>> > > // <smpl>
>> > > @@
>> > > identifier struct_name;
>> > > struct struct_name to;
>> > > struct struct_name from;
>> > > expression E;
>> > > @@
>> > > -memcpy(&(to), &(from), E);
>> > > +to = from;
>> > > // </smpl>
>> > >
>> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> > > Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> > > ---
>> > >
>> > >  drivers/media/usb/uvc/uvc_v4l2.c |    6 +++---
>> > >  1 files changed, 3 insertions(+), 3 deletions(-)
>> > >
>> > > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
>> > > b/drivers/media/usb/uvc/uvc_v4l2.c index f00db30..4fc8737 100644
>> > > --- a/drivers/media/usb/uvc/uvc_v4l2.c
>> > > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>> > > @@ -314,7 +314,7 @@ static int uvc_v4l2_set_format(struct uvc_streaming
>> > > *stream,
>> > >                 goto done;
>> > >         }
>> > >
>> > > -       memcpy(&stream->ctrl, &probe, sizeof probe);
>> > > +       stream->ctrl = probe;
>> > >
>> > >         stream->cur_format = format;
>> > >         stream->cur_frame = frame;
>> > > @@ -386,7 +386,7 @@ static int uvc_v4l2_set_streamparm(struct
>> > > uvc_streaming *stream,
>> > >                 return -EBUSY;
>> > >         }
>> > >
>> > > -       memcpy(&probe, &stream->ctrl, sizeof probe);
>> > > +       probe = stream->ctrl;
>> > >         probe.dwFrameInterval =
>> > >                 uvc_try_frame_interval(stream->cur_frame, interval);
>> > >
>> > > @@ -397,7 +397,7 @@ static int uvc_v4l2_set_streamparm(struct
>> > > uvc_streaming *stream,
>> > >                 return ret;
>> > >         }
>> > >
>> > > -       memcpy(&stream->ctrl, &probe, sizeof probe);
>> > > +       stream->ctrl = probe;
>> > >         mutex_unlock(&stream->mutex);
>> > >
>> > >         /* Return the actual frame period. */
>> >
>> > It seems you've marked this one as "Changes requested" [1].
>> > However, Laurent didn't request any change,
>> > but just pointed out we missed one memcpy replacement candidate.
>> >
>> > I believe it's safe to apply the patch (together with the other 20
>> > patches) and we can fix the missing spot in another patch.
>>
>> The other patches got applied already. Well just do whatever Laurent asked
>> you and re-submit this one ;)
>
> Could you please resubmit this patch with the missed memcpy replaced by a
> struct assignment ? I'll then add it to my tree.
>

Sure!

Thanks,

-- 
    Ezequiel
