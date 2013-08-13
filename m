Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3HMCqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:46:54 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47212 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab3HMCqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:46:53 -0400
MIME-Version: 1.0
In-Reply-To: <BD586D1F-DC60-46A7-AB20-EEC959380CA6@codeaurora.org>
References: <1376202321-25175-1-git-send-email-prabhakar.csengg@gmail.com> <BD586D1F-DC60-46A7-AB20-EEC959380CA6@codeaurora.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 13 Aug 2013 08:16:31 +0530
Message-ID: <CA+V-a8sJhe9AqXN2x3cZPcU4W7NfuqeKkZrr7SZ_wymb7JQCrQ@mail.gmail.com>
Subject: Re: [PATCH v5] media: i2c: tvp7002: add OF support
To: Kumar Gala <galak@codeaurora.org>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 6:30 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Aug 11, 2013, at 1:25 AM, Lad, Prabhakar wrote:
>
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> add OF support for the tvp7002 driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>> This patch depends on https://patchwork.kernel.org/patch/2842680/
>>
>> Changes for v5:
>> 1: Fixed review comments pointed by Hans.
>>
>> Changes for v4:
>> 1: Improved descrition of end point properties.
>>
>> Changes for v3:
>> 1: Fixed review comments pointed by Sylwester.
>>
>> .../devicetree/bindings/media/i2c/tvp7002.txt      |   53 ++++++++++++++++
>> drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
>> 2 files changed, 113 insertions(+), 7 deletions(-)
>> create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> new file mode 100644
>> index 0000000..5f28b5d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> @@ -0,0 +1,53 @@
>> +* Texas Instruments TV7002 video decoder
>> +
>> +The TVP7002 device supports digitizing of video and graphics signal in RGB and
>> +YPbPr color space.
>> +
>> +Required Properties :
>> +- compatible : Must be "ti,tvp7002"
>> +
>> +Optional Properties:
>
>
>> +- hsync-active: HSYNC Polarity configuration for the bus. Default value when
>> +  this property is not specified is <0>.
>> +
>> +- vsync-active: VSYNC Polarity configuration for the bus. Default value when
>> +  this property is not specified is <0>.
>> +
>> +- pclk-sample: Clock polarity of the bus. Default value when this property is
>> +  not specified is <0>.
>> +
>> +- sync-on-green-active: Active state of Sync-on-green signal property of the
>> +  endpoint.
>> +  0 = Normal Operation (Active Low, Default)
>> +  1 = Inverted operation
>
> These seems better than what you have in video-interfaces.txt
>
Well it sounds the same, I would keep it as is, let me know if you still
want me to change.

>> +
>> +- field-even-active: Active-high Field ID output polarity control of the bus.
>> +  Under normal operation, the field ID output is set to logic 1 for an odd field
>> +  (field 1) and set to logic 0 for an even field (field 0).
>> +  0 = Normal Operation (Active Low, Default)
>> +  1 = FID output polarity inverted
>> +
>
> Why the duplication if this is covered in video-interfaces.txt?
>
The explanation in  video-interfaces.txt is more kind of generic and
the explanation
here is specific to this device.

Regards,
--Prabhakar Lad
