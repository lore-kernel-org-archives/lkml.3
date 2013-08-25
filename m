Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3HYPdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 11:33:13 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42550 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3HYPdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 11:33:11 -0400
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v5] media: i2c: tvp7002: add OF support
References: <1376202321-25175-1-git-send-email-prabhakar.csengg@gmail.com> <BD586D1F-DC60-46A7-AB20-EEC959380CA6@codeaurora.org> <52179B03.8090402@samsung.com>
From: naim.dahnoun@googlemail.com
Mime-Version: 1.0 (1.0)
In-Reply-To: <52179B03.8090402@samsung.com>
Message-Id: <07E2F059-EB81-47F7-814E-C55073144FD2@gmail.com>
Date: Sun, 25 Aug 2013 16:23:41 +0100
Cc: Kumar Gala <galak@codeaurora.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "<linux-doc@vger.kernel.org>" <linux-doc@vger.kernel.org>,
        "<devicetree-discuss@lists.ozlabs.org>" 
	<devicetree-discuss@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
X-Mailer: iPhone Mail (10A523)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sent from my iPhone

On 23 Aug 2013, at 18:25, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:

> On 08/13/2013 03:00 AM, Kumar Gala wrote:
>> On Aug 11, 2013, at 1:25 AM, Lad, Prabhakar wrote:
>> 
>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>> 
>>> add OF support for the tvp7002 driver.
>>> 
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> ---
> [...]
>>> .../devicetree/bindings/media/i2c/tvp7002.txt      |   53 ++++++++++++++++
>>> drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
>>> 2 files changed, 113 insertions(+), 7 deletions(-)
>>> create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>> 
>>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>> new file mode 100644
>>> index 0000000..5f28b5d
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>> @@ -0,0 +1,53 @@
>>> +* Texas Instruments TV7002 video decoder
>>> +
>>> +The TVP7002 device supports digitizing of video and graphics signal in RGB and
>>> +YPbPr color space.
>>> +
>>> +Required Properties :
>>> +- compatible : Must be "ti,tvp7002"
>>> +
>>> +Optional Properties:
>> 
>> 
>>> +- hsync-active: HSYNC Polarity configuration for the bus. Default value when
>>> +  this property is not specified is <0>.
>>> +
>>> +- vsync-active: VSYNC Polarity configuration for the bus. Default value when
>>> +  this property is not specified is <0>.
>>> +
>>> +- pclk-sample: Clock polarity of the bus. Default value when this property is
>>> +  not specified is <0>.
>>> +
>>> +- sync-on-green-active: Active state of Sync-on-green signal property of the
>>> +  endpoint.
>>> +  0 = Normal Operation (Active Low, Default)
>>> +  1 = Inverted operation
>> 
>> These seems better than what you have in video-interfaces.txt
> 
> We probably should specify default values in in the common binding description.
> Then duplication could be avoided. Not sure if it's not too late for this, all
> drivers would need to have same default values.
> 
> What's normal and what's inverted depends on a particular device.
> 
>>> +- field-even-active: Active-high Field ID output polarity control of the bus.
>>> +  Under normal operation, the field ID output is set to logic 1 for an odd field
>>> +  (field 1) and set to logic 0 for an even field (field 0).
>>> +  0 = Normal Operation (Active Low, Default)
>>> +  1 = FID output polarity inverted
>>> +
>> 
>> Why the duplication if this is covered in video-interfaces.txt?
> 
> Yes, it would be better to avoid redefining these properties in each specific 
> device's binding. Presumably, for easier matching of DT properties with the
> hardware's description, we could only say in device specific document which
> value of a property corresponds to "normal" and which to "inverted" operation ?
> 
>>> +For further reading of port node refer Documentation/devicetree/bindings/media/
>>> +video-interfaces.txt.
> 
> -- 
> Sylwester Nawrocki
> Samsung R&D Institute Poland
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
