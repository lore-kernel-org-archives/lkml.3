Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3EPKyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:54:43 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:40601 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3EPKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <5194B8DA.4080204@gmail.com>
References: <1368622349-32185-1-git-send-email-prabhakar.csengg@gmail.com> <5194B8DA.4080204@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 16 May 2013 16:24:19 +0530
Message-ID: <CA+V-a8v9AuwyQqnSekASGyVHz9RRux+ttQqPf+35rux5YehaCw@mail.gmail.com>
Subject: Re: [PATCH RFC] media: OF: add field-active and sync-on-green
 endpoint properties
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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

Hi Sylwester,

Thanks for the review.

On Thu, May 16, 2013 at 4:15 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 05/15/2013 02:52 PM, Lad Prabhakar wrote:
>>
>> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> index e022d2d..6bf87d0 100644
>> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
>> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
>> @@ -101,6 +101,10 @@ Optional endpoint properties
>>     array contains only one entry.
>>   - clock-noncontinuous: a boolean property to allow MIPI CSI-2
>> non-continuous
>>     clock mode.
>> +-field-active: a boolean property indicating active high filed ID output
>> + polarity is inverted.
>
>
> You can drop this property and use the existing 'field-even-active' property
> instead.
>
OK

>
>> +-sync-on-green: a boolean property indicating to sync with the green
>> signal in
>> + RGB.
>
>
>> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
>> index 83ae07e..b95553d 100644
>> --- a/include/media/v4l2-mediabus.h
>> +++ b/include/media/v4l2-mediabus.h
>> @@ -40,6 +40,8 @@
>>   #define V4L2_MBUS_FIELD_EVEN_HIGH             (1<<  10)
>>   /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
>>   #define V4L2_MBUS_FIELD_EVEN_LOW              (1<<  11)
>> +#define V4L2_MBUS_FIELD_ACTIVE                 (1<<  12)
>> +#define V4L2_MBUS_SOG                          (1<<  13)
>
>
> How about V4L2_MBUS_SYNC_ON_GREEN ?
>
OK makes it more readable.

Regards,
--Prabhakar Lad
