Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3EPEx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:53:59 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51538 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3EPEx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <2510029.UKsn4JyZOW@avalon>
References: <1368622349-32185-1-git-send-email-prabhakar.csengg@gmail.com> <2510029.UKsn4JyZOW@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 16 May 2013 10:23:34 +0530
Message-ID: <CA+V-a8tsohAyGRCn3NhwsS19X84N_xOwLB_wd0bPvyu1fLy3+g@mail.gmail.com>
Subject: Re: [PATCH RFC] media: OF: add field-active and sync-on-green
 endpoint properties
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, May 15, 2013 at 6:54 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Wednesday 15 May 2013 18:22:29 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch adds "field-active" and "sync-on-green" as part of
>> endpoint properties and also support to parse them in the parser.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  .../devicetree/bindings/media/video-interfaces.txt |    4 ++++
>>  drivers/media/v4l2-core/v4l2-of.c                  |    6 ++++++
>>  include/media/v4l2-mediabus.h                      |    2 ++
>>  3 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> b/Documentation/devicetree/bindings/media/video-interfaces.txt index
>> e022d2d..6bf87d0 100644
>> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> @@ -101,6 +101,10 @@ Optional endpoint properties
>>    array contains only one entry.
>>  - clock-noncontinuous: a boolean property to allow MIPI CSI-2
>> non-continuous clock mode.
>> +-field-active: a boolean property indicating active high filed ID output
>> + polarity is inverted.
>
> Looks like we already have field-even-active property to describe the level of
> the field signal. Could you please check whether it fulfills your use cases ?
> Sorry for not pointing you to it earlier.
>
I had looked at it earlier it only means "field signal level during the even
field data transmission" it only speaks of even filed. Ideally the field ID
output is set to logic 1 for odd field and set to 0 for even field, what I
want is to invert the FID out polarity when "field-active" property is set.

May be we rename "field-active" to "fid-pol" ?

Regards,
--Prabhakar Lad
