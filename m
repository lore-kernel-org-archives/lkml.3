Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3E2ET1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 00:19:27 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62577 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3E2ETZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 00:19:25 -0400
MIME-Version: 1.0
In-Reply-To: <1417519.vVjfDJcATe@avalon>
References: <1369574386-24486-1-git-send-email-prabhakar.csengg@gmail.com> <1417519.vVjfDJcATe@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 29 May 2013 09:49:03 +0530
Message-ID: <CA+V-a8vn7VOKjJ5EWnT-=eGeUgAwsUyeAF-bv1N6w3HmRefgBQ@mail.gmail.com>
Subject: Re: [PATCH v5] media: i2c: tvp514x: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, May 29, 2013 at 6:52 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thanks for the patch.
>
> On Sunday 26 May 2013 18:49:46 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> add OF support for the tvp514x driver.
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
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
Thanks for the ack.

> (with two small comment below).
>
>> ---
>> Tested on da850-evm.
>>
[snip]
>
> s/of port/on port/
> s/refer/refer to/
>
OK

>> Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +
>> +     i2c0@1c22000 {
>> +             ...
>> +             ...
>> +             tvp514x@5c {
>> +                     compatible = "ti,tvp5146";
>> +                     reg = <0x5c>;
>> +
>> +                     port {
>> +                             tvp514x_1: endpoint {
>> +                                     hsync-active = <1>;
>> +                                     vsync-active = <1>;
>> +                                     pclk-sample = <0>;
>> +                             };
>> +                     };
>> +             };
>> +             ...
>> +     };
>> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
>> index 7438e01..7ed999b 100644
>> --- a/drivers/media/i2c/tvp514x.c
>> +++ b/drivers/media/i2c/tvp514x.c
>> @@ -39,6 +39,7 @@
>>  #include <media/v4l2-device.h>
>>  #include <media/v4l2-common.h>
>>  #include <media/v4l2-mediabus.h>
>> +#include <media/v4l2-of.h>
>>  #include <media/v4l2-chip-ident.h>
>>  #include <media/v4l2-ctrls.h>
>>  #include <media/tvp514x.h>
>> @@ -1055,6 +1056,42 @@ static struct tvp514x_decoder tvp514x_dev = {
>>
>>  };
>>
>> +static struct tvp514x_platform_data *
>> +tvp514x_get_pdata(struct i2c_client *client)
>> +{
>> +     struct tvp514x_platform_data *pdata = NULL;
>
> No need to initialize pdata to NULL.
>
OK will fix it in the next version.

Regards,
--Prabhakar Lad
