Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab3EPKnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:43:11 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:37139 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3EPKnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:43:08 -0400
Message-ID: <5194B836.1020808@gmail.com>
Date: Thu, 16 May 2013 12:43:02 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC] media: OF: add field-active and sync-on-green endpoint
 properties
References: <1368622349-32185-1-git-send-email-prabhakar.csengg@gmail.com> <2510029.UKsn4JyZOW@avalon> <CA+V-a8tsohAyGRCn3NhwsS19X84N_xOwLB_wd0bPvyu1fLy3+g@mail.gmail.com>
In-Reply-To: <CA+V-a8tsohAyGRCn3NhwsS19X84N_xOwLB_wd0bPvyu1fLy3+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/16/2013 06:53 AM, Prabhakar Lad wrote:
>>> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
>>> >>  b/Documentation/devicetree/bindings/media/video-interfaces.txt index
>>> >>  e022d2d..6bf87d0 100644
>>> >>  --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
>>> >>  +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
>>> >>  @@ -101,6 +101,10 @@ Optional endpoint properties
>>> >>      array contains only one entry.
>>> >>    - clock-noncontinuous: a boolean property to allow MIPI CSI-2
>>> >>  non-continuous clock mode.
>>> >>  +-field-active: a boolean property indicating active high filed ID output
>>> >>  + polarity is inverted.
>> >
>> >  Looks like we already have field-even-active property to describe the level of
>> >  the field signal. Could you please check whether it fulfills your use cases ?
>> >  Sorry for not pointing you to it earlier.
>> >
> I had looked at it earlier it only means "field signal level during the even
> field data transmission" it only speaks of even filed. Ideally the field ID
> output is set to logic 1 for odd field and set to 0 for even field, what I
> want is to invert the FID out polarity when "field-active" property is set.
>
> May be we rename "field-active" to "fid-pol" ?

I guess we failed to clearly describe the 'field-even-active' property then.
It seems to be exactly what you need.

It is not enough to say e.g. field-active = <1>;, because it would not have
been clear which field it refers to, odd or even ? Unlike VSYNC, HSYNC both
levels of the FIELD signal are "active", there is no "idle" state for FIELD.

So field-even-active = <1>; means the FIELD signal at logic high level
indicates EVEN field _and_ this implies FIELD = 0 indicates ODD field, i.e.

FIELD = 0 => odd field
FIELD = 1 => even field

For field-even-active = <0>; it is the other way around:

FIELD = 0 => even field
FIELD = 1 => odd field

It looks like only "sync-on-green" property is missing. BTW, is it really
commonly used ? What drivers would need it ?
I'm not against making it a common property, it's just first time I see it.

Thanks,
Sylwester
