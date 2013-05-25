Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3EYJR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 05:17:57 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:61210 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3EYJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 05:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <519F4AE7.8000003@gmail.com>
References: <1368710287-8741-1-git-send-email-prabhakar.csengg@gmail.com> <519F4AE7.8000003@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 25 May 2013 14:47:33 +0530
Message-ID: <CA+V-a8tMQnjh=8qaRoNhwkdrcoTCK2zofTkCOd79hAMoz5qK2A@mail.gmail.com>
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

On Fri, May 24, 2013 at 4:41 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Prabhakar,
>
>
> On 05/16/2013 03:18 PM, Lad Prabhakar wrote:
>>
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch adds "sync-on-green" property as part of
>> endpoint properties and also support to parse them in the parser.
>
>
>> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> @@ -101,6 +101,8 @@ Optional endpoint properties
>>     array contains only one entry.
>>   - clock-noncontinuous: a boolean property to allow MIPI CSI-2
>> non-continuous
>>     clock mode.
>> +-sync-on-green: a boolean property indicating to sync with the green
>> signal in
>> + RGB.
>
>
> Are you sure this is what you need for the TVP7002 chip ?
>
Yes

> I think we should differentiate between analog and digital signals and the
> related
> device's configuration. AFAIU for the analog part there can be various video
> sychronisation methods, i.e. ways in which the synchronisation signals are
> transmitted along side the video component (RGB or luma/chroma) signals.
> According
> to [1] (presumably not most reliable source of information) there are
> following
> methods of transmitting sync signals:
>
>  - Separate sync
>  - Composite sync
>  - Sync-on-green (SOG)
>  - Sync-on-luminance
>  - Sync-on-composite
>
> And all these seem to refer to analog video signal.
>
I was about to add all these but as per Laurent mentioned we can add this
whenever there is a need of it.

> From looking at Figure 8 "TVP7002 Application Example" in the TVP7002's
> datasheet
> ([2], p. 52) and your initial TVP7002 patches it looks like what you want is
> to
> specify polarity of the SOGOUT signal, so the processor that receives this
> signal
> can properly interpret it, is it correct ?
>
Yes
> If so then wouldn't it be more appropriate to define e.g. 'sog-active'
> property
> and media bus flags:
>         V4L2_MBUS_SYNC_ON_GREEN_ACTIVE_LOW
>         V4L2_MBUS_SYNC_ON_GREEN_ACTIVE_HIGH
> ?
>
Agreed I'll add these flags.

> And for synchronisation method on the analog part we could perhaps define
> 'component-sync' or similar property that would enumerate all possible
> synchronisation methods. We might as well use separate boolean properties,
> but I'm a bit concerned about the increasing number of properties that need
> to be parsed for each parallel video bus "endpoint".
>
I am not clear on it can please elaborate more on this.

Regards,
--Prabhakar Lad
