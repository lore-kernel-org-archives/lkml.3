Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbaCTMg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:36:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60518 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754990AbaCTMg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:36:56 -0400
Date: Thu, 20 Mar 2014 12:36:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT
	documentation
Message-ID: <20140320123640.GR7528@n2100.arm.linux.org.uk>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr> <532ADFD8.80301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532ADFD8.80301@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 01:32:24PM +0100, Sebastian Hesselbarth wrote:
> On 03/20/2014 09:58 AM, Jean-Francois Moine wrote:
>> The I2C address (reg) is required for the TDA998x driver to be loaded
>> and initialized.
>>
>> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>> ---
>> This patch applies to linux-next.
>> ---
>>   Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
>> index d7df01c..fc7effa 100644
>> --- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
>> +++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
>> @@ -3,6 +3,8 @@ Device-Tree bindings for the NXP TDA998x HDMI transmitter
>>   Required properties;
>>     - compatible: must be "nxp,tda998x"
>>
>> +  - reg: I2C address - must be <0x70>
>
> TDA9983b datasheet says:
>
> "Bits A0 and A1 of the I2C-bus device address are externally selected
> by pins A0 and A1."
>
> Therefore, 0x70, 0x71, 0x72, and 0x73 are valid i2c addresses.

Thanks Sebastian, those kinds of details are very important to get right
when it comes to the binding doc, much more so than what's in the code.
It probably makes more sense not to specify what the address actually is.
After all, that's a specification by the data sheet and software shouldn't
really care what that is.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
