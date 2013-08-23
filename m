Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3HWRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:25:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46628 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3HWRZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:25:27 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-32-52179b053c9f
Message-id: <52179B03.8090402@samsung.com>
Date: Fri, 23 Aug 2013 19:25:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Kumar Gala <galak@codeaurora.org>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5] media: i2c: tvp7002: add OF support
References: <1376202321-25175-1-git-send-email-prabhakar.csengg@gmail.com>
 <BD586D1F-DC60-46A7-AB20-EEC959380CA6@codeaurora.org>
In-reply-to: <BD586D1F-DC60-46A7-AB20-EEC959380CA6@codeaurora.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7qss8WDDCYe57Q4d6uB1eLA7Ies
	Fv1vFrJanJr8jMliYdsSFovLu+awWfRs2MpqcXGdvMXL+yuYHTg9Lvf1MnnsnHWX3WPOtCYW
	j/MzFjJ69G1ZxejxeZOcx6mvn9kD2KO4bFJSczLLUov07RK4Mh5/m8VS0C1e0bP7AlsD4y2h
	LkZODgkBE4mHJ6awQ9hiEhfurWfrYuTiEBJYyigxbd91ZgjnE6PEqxtTmboYOTh4BbQklkz3
	BWlgEVCVODLpARuIzSZgKNF7tI8RxBYVCJBYvOQc2FBeAUGJH5PvsYDYIkD1y+duZgGZySxw
	hkli1ZotrCAzhQWsJXavlYfY1cQoceD+VVaQBk4BJ4l7N8+CLWAW0JHY3zoNypaX2LzmLfME
	RoFZSHbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh0fB1B+PSY1aHGAU4
	GJV4eFe0iAcJsSaWFVfmHmKU4GBWEuF9Wg0U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLik4n3e
	v3lGdmpMrdNC0ybL2lypOdIhzvNrm8c/BgbFdx6SAReT/E/W1Ug9+MXWt7jx7/RFSkwXkiaY
	/npY6lZWnWVycG67lehJu7f/HuzROrfo0vbmp5VHdmyVWxMYsDNu7vnYzKynUsXrpy1cdb3+
	2aqwpd9DhV6fumPA/ENj7o40jfVCfepKLMUZiYZazEXFiQAC/Yd3ZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 03:00 AM, Kumar Gala wrote:
> On Aug 11, 2013, at 1:25 AM, Lad, Prabhakar wrote:
> 
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> add OF support for the tvp7002 driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
[...]
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

We probably should specify default values in in the common binding description.
Then duplication could be avoided. Not sure if it's not too late for this, all
drivers would need to have same default values.

What's normal and what's inverted depends on a particular device.

>> +- field-even-active: Active-high Field ID output polarity control of the bus.
>> +  Under normal operation, the field ID output is set to logic 1 for an odd field
>> +  (field 1) and set to logic 0 for an even field (field 0).
>> +  0 = Normal Operation (Active Low, Default)
>> +  1 = FID output polarity inverted
>> +
> 
> Why the duplication if this is covered in video-interfaces.txt?

Yes, it would be better to avoid redefining these properties in each specific 
device's binding. Presumably, for easier matching of DT properties with the
hardware's description, we could only say in device specific document which
value of a property corresponds to "normal" and which to "inverted" operation ?
 
>> +For further reading of port node refer Documentation/devicetree/bindings/media/
>> +video-interfaces.txt.

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
