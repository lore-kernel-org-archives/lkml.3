Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3EHEsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:48:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41898 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3EHEsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <2799899.cTq52i3x0Z@avalon>
References: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com> <2799899.cTq52i3x0Z@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 8 May 2013 10:17:51 +0530
Message-ID: <CA+V-a8tcDi3sTyyLvjcX87ZaKSqUU8fWc07LkRgRsAiDS+ov2g@mail.gmail.com>
Subject: Re: [PATCH RFC v3] media: i2c: mt9p031: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Laurent,

On Wed, May 8, 2013 at 7:31 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Friday 03 May 2013 12:21:59 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> add OF support for the mt9p031 sensor driver.
>> Alongside this patch sorts the header inclusion alphabetically.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  Changes for v2:
>>  1: Used '-' instead of '_' for device properties.
>>  2: Specified gpio reset pin as phandle in device node.
>>  3: Handle platform data properly even if kernel is compiled with
>>     devicetree support.
>>  4: Used dev_* for messages in drivers instead of pr_*.
>>  5: Changed compatible property to "aptina,mt9p031" and "aptina,mt9p031m".
>>  6: Sorted the header inclusion alphabetically and fixed some minor code
>> nits.
>>
>> Changes for v3:
>>  1: Dropped check if gpio-reset is valid.
>>  2: Fixed some code nits.
>>  3: Included a reference to the V4L2 DT bindings documentation.
>>
>>  .../devicetree/bindings/media/i2c/mt9p031.txt      |   40 +++++++++++++
>>  drivers/media/i2c/mt9p031.c                        |   60 ++++++++++++++++-
>>  2 files changed, 97 insertions(+), 3 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
>> b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt new file mode
>> 100644
>> index 0000000..e740541
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
>> @@ -0,0 +1,40 @@
>> +* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
>> +
>> +The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image sensor
>> with +an active array size of 2592H x 1944V. It is programmable through a
>> simple +two-wire serial interface.
>> +
>> +Required Properties :
>> +- compatible : value should be either one among the following
>> +     (a) "aptina,mt9p031" for mt9p031 sensor
>> +     (b) "aptina,mt9p031m" for mt9p031m sensor
>> +
>> +- input-clock-frequency : Input clock frequency.
>> +
>> +- pixel-clock-frequency : Pixel clock frequency.
>> +
>> +Optional Properties :
>> +-gpio-reset: Chip reset GPIO
>
> According to Documentation/devicetree/bindings/gpio/gpio.txt, this should be
> "gpios" or "reset-gpios".
>
OK I'll make it as "reset-gpios"

Regards,
--Prabhakar Lad
