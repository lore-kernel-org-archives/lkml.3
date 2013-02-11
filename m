Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab3BKPOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:14:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40423 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255Ab3BKPOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:14:44 -0500
Message-ID: <51190AD2.3030006@ti.com>
Date: Mon, 11 Feb 2013 17:14:26 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kishon@ti.com" <kishon@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/14] usb: phy: nop: Add device tree support and binding
 information
References: <1360252974-7912-1-git-send-email-rogerq@ti.com> <1360252974-7912-2-git-send-email-rogerq@ti.com> <20130211114040.GA2726@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130211114040.GA2726@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 01:40 PM, Mark Rutland wrote:
> Hello,
> 
> On Thu, Feb 07, 2013 at 04:02:41PM +0000, Roger Quadros wrote:
>> The PHY clock, clock rate, VCC regulator and RESET regulator
>> can now be provided via device tree.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>> ---
>>  .../devicetree/bindings/usb/usb-nop-xceiv.txt      |   34 ++++++++++++++++++
>>  drivers/usb/otg/nop-usb-xceiv.c                    |   36 +++++++++++++++----
>>  2 files changed, 62 insertions(+), 8 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
>>
>> diff --git a/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt b/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
>> new file mode 100644
>> index 0000000..d7e2726
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt
>> @@ -0,0 +1,34 @@
>> +USB NOP PHY
>> +
>> +Required properties:
>> +- compatible: should be usb-nop-xceiv
> 
> This might be better as "linux,usb-no-xceiv", given this is a Linux-specific
> 'device'.
> 
> Saying that, I'm not sure I understand why this device needs to be instantiated
> from devicetree. As I understand it from looking at the driver, it's purely a
> Linux implementation detail used in the case of autonomous PHYs, and not an
> actual piece of hardware or firmware system. I must admit to being unfamiliar
> with this area of hardware, have I misunderstood somethign here?

The PHY is a physical device and may need resources like power and clock to be functional.
The only reason that driver is named NOP is that many USB controllers know how to talk to
the standard PHYs and don't need any interface/management software.

The PHY driver you are looking at most likely doesn't have the recent changes I wrote to
manage the PHY clock/reset/power. i.e. patches 3, 4 and 5 in the series
 https://lkml.org/lkml/2013/1/28/275

Before this, the ehci-omap driver was trying to manage the PHY power and reset, which was
wrong.

regards,
-roger
