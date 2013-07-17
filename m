Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3GQRY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:24:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49241 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab3GQRYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:24:54 -0400
MIME-Version: 1.0
In-Reply-To: <51E6C8D8.4010303@samsung.com>
References: <1374078016-17122-1-git-send-email-prabhakar.csengg@gmail.com> <51E6C8D8.4010303@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 17 Jul 2013 22:54:32 +0530
Message-ID: <CA+V-a8uKHymsWw1mZMH==Q6--F23y_xnFKtZDVB5r12K3=5zyQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: i2c: tvp7002: add OF support
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>, devicetree-discuss@lists.ozlabs.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Thanks for the quick review.

On Wed, Jul 17, 2013 at 10:09 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 07/17/2013 06:20 PM, Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> add OF support for the tvp7002 driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  This patch depends on https://patchwork.kernel.org/patch/2828800/
>>
>>  Changes for v3:
>>  1: Fixed review comments pointed by Sylwester.
>>
>>  .../devicetree/bindings/media/i2c/tvp7002.txt      |   43 +++++++++++++
>>  drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
>>  2 files changed, 103 insertions(+), 7 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> new file mode 100644
>> index 0000000..744125f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> @@ -0,0 +1,43 @@
>> +* Texas Instruments TV7002 video decoder
>> +
>> +The TVP7002 device supports digitizing of video and graphics signal in RGB and
>> +YPbPr color space.
>> +
>> +Required Properties :
>> +- compatible : Must be "ti,tvp7002"
>> +
>> +- hsync-active: HSYNC Polarity configuration for endpoint.
>> +
>> +- vsync-active: VSYNC Polarity configuration for endpoint.
>
> I woudn't refer to "endpoint" here, perhaps to the specific hardware
> bus instead ? So it is clear what part of the device it refers to ?
>
OK, I'll refer to bus instead.

>> +- pclk-sample: Clock polarity of the endpoint.
>
> This description is not very useful, my feeling is that this property
> is better described in video-interfaces.txt.
>
agreed its just a one liner, and below I have mentioned a link
to video-interfaces.txt for better understanding of this generic
properties.

>> +- sync-on-green-active: Active state of Sync-on-green signal property of the
>> +  endpoint, 0/1 for normal/inverted operation respectively.
>> +
>> +- field-even-active: Active-high Field ID polarity of the endpoint.
>
> I find it hard to understand what this property is about exactly.
> Not sure if you need to repeat detailed description of the signal
> polarity properties. Perhaps its sufficient to list which properties
> are relevant for this device, but I'm not opposed to having
> supplementary description here. I would just make it more specific
> to the TVP7002 chip.

How about the below description ?

Active-high Field ID output polarity control. Under normal operation, the
field ID output is set to logic 1 for an odd field (field 1)
and set to logic 0 for an even field (field 0).
0 = Normal operation (default)
1 = FID output polarity inverted

> Also please note that only 'compatible' property is required, all
> other are optional. And it probably makes sense to specify what are
> default values for each property when it is not specified.
>
Agreed I'll add them to optional list, and mention their default values too.

--
Regards,
Prabhakar Lad
