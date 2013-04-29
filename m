Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3D2Rwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:52:32 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:57311 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab3D2Ruq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:50:46 -0400
MIME-Version: 1.0
In-Reply-To: <1696679.tiFHy28fsU@avalon>
References: <1366963535-15963-1-git-send-email-prabhakar.csengg@gmail.com>
 <32556864.ElKWl0cdN2@avalon> <CA+V-a8u_YA=TJaRebboigM6z-A=R6-ZdyxZSED7H+4w+LN+cTQ@mail.gmail.com>
 <1696679.tiFHy28fsU@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 29 Apr 2013 23:20:24 +0530
Message-ID: <CA+V-a8tE4SHk2VCRPBTX5CixPip95KduzMSdGt7PEWtFLu52gQ@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: tvp7002: enable TVP7002 decoder for media
 controller based usage
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Mon, Apr 29, 2013 at 11:06 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Monday 29 April 2013 23:00:26 Prabhakar Lad wrote:
>> On Mon, Apr 29, 2013 at 7:57 PM, Laurent Pinchart wrote:
>> > On Friday 26 April 2013 13:35:35 Prabhakar Lad wrote:
>> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> >>
>> >> This patch enables tvp7002 decoder driver for media controller
>> >> based usage by adding v4l2_subdev_pad_ops  operations support
>> >> for enum_mbus_code, set_pad_format, get_pad_format and
>> >> media_entity_init()
>> >> on probe and media_entity_cleanup() on remove.
>> >>
>> >> The device supports 1 output pad and no input pads.
>> >
>> > We should actually define input pads, connected to connector entities, but
>> > that's out of scope for this patch.
>> >
>> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> >> ---
>
[snip]

>> >> +/* media pad related operation handlers */
>> >> +static const struct v4l2_subdev_pad_ops tvp7002_pad_ops = {
>> >> +     .enum_mbus_code = tvp7002_enum_mbus_code,
>> >> +     .get_fmt = tvp7002_get_pad_format,
>> >> +     .set_fmt = tvp7002_set_pad_format,
>> >
>> > We will need to define pad-aware DV timings operations.
>>
>> I didn't get you this?
>
> We will need to extend the pad operations (struct v4l2_subdev_pad_ops) with
> operations to enumerate, get and set DV timings at the pad level.
>
not sure if exposing get and set DV timings at the pad level would be a better
idea, timings for pad's would be the same always and anyways we get DV timings
on video node. I cant think of usecase where we require get and set DV
timings at the pad level.

Regards,
--Prabhakar Lad
