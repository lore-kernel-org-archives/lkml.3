Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3EYO1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 10:27:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48726 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3EYO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 10:27:03 -0400
MIME-Version: 1.0
In-Reply-To: <51A0C6A8.5090302@gmail.com>
References: <1368710287-8741-1-git-send-email-prabhakar.csengg@gmail.com>
 <519F4AE7.8000003@gmail.com> <CA+V-a8tMQnjh=8qaRoNhwkdrcoTCK2zofTkCOd79hAMoz5qK2A@mail.gmail.com>
 <51A0C6A8.5090302@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 25 May 2013 19:56:41 +0530
Message-ID: <CA+V-a8tqQGk1v_QdSsn2rt-OJY5PxoFmr1LLkp1bQQb3GuerMA@mail.gmail.com>
Subject: Re: [PATCH RFC v2] media: OF: add sync-on-green endpoint property
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Sat, May 25, 2013 at 7:41 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi,
>
>
> On 05/25/2013 11:17 AM, Prabhakar Lad wrote:
>>>
>>>  From looking at Figure 8 "TVP7002 Application Example" in the TVP7002's
>>> >  datasheet
>>> >  ([2], p. 52) and your initial TVP7002 patches it looks like what you
>>> > want is
>>> >  to
>>> >  specify polarity of the SOGOUT signal, so the processor that receives
>>> > this
>>> >  signal
>>> >  can properly interpret it, is it correct ?
>>> >
>>
>> Yes
>>>
>>> >  If so then wouldn't it be more appropriate to define e.g. 'sog-active'
>>> >  property
>>> >  and media bus flags:
>>> >           V4L2_MBUS_SYNC_ON_GREEN_ACTIVE_LOW
>>> >           V4L2_MBUS_SYNC_ON_GREEN_ACTIVE_HIGH
>>> >  ?
>>> >
>>
>> Agreed I'll add these flags.
>>
>>> >  And for synchronisation method on the analog part we could perhaps
>>> > define
>>> >  'component-sync' or similar property that would enumerate all possible
>>> >  synchronisation methods. We might as well use separate boolean
>>> > properties,
>>> >  but I'm a bit concerned about the increasing number of properties that
>>> > need
>>> >  to be parsed for each parallel video bus "endpoint".
>>> >
>>
>> I am not clear on it can please elaborate more on this.
>
>
> I thought about two possible options:
>
> 1. single property 'component-sync' or 'video-sync' that would have values:
>
> #define VIDEO_SEPARATE_SYNC     0x01
> #define VIDEO_COMPOSITE_SYNC    0x02
> #define VIDEO_SYNC_ON_COMPOSITE 0x04
> #define VIDEO_SYNC_ON_GREEN     0x08
> #define VIDEO_SYNC_ON_LUMINANCE 0x10
>
> And we could put these definitions into a separate header, e.g.
> <dt-bindings/video-interfaces.h>
>
> Then in a device tree source file one could have, e.g.
>
> video-sync = <VIDEO_SYNC_ON_GREEN>;
>
>
> 2. Separate boolean property for each video sync type, e.g.
>
>         "video-composite-sync"
>         "video-sync-on-composite"
>         "video-sync-on-green"
>         "video-sync-on-luminance"
>
> Separate sync, with separate VSYNC, HSYNC lines, would be the default, when
> none of the above is specified and 'vsync-active', 'hsync-active' properties
> are present.
>
> However, I suppose the better would be to deduce the video synchronisation
> method from the sync signal polarity flags. Then, for instance, when an
> endpoint node contains "composite-sync-active" property the parser would
> determine the "composite sync" synchronisation type is used.
>
> Thus it might make sense to have only following integer properties (added
> as needed):
>
> composite-sync-active
> sync-on-green-active
> sync-on-comp-active
> sync-on-luma-active
>
> This would allow to specify polarity of each signal and at the same time
> the parsing code could derive synchronisation type. A new field could be
> added to struct v4l2_of_parallel_bus, e.g. sync_type and it would be filled
> within v4l2_of_parse_endpoint().
>
I am OK with this option. and I hope you meant "struct
v4l2_of_bus_parallel" instead
of " struct v4l2_of_parallel_bus" and to fill sync_type within
v4l2_of_parse_parallel_bus()
and not in v4l2_of_parse_endpoint().

Regards,
--Prabhakar Lad
