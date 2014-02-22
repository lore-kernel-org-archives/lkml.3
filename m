Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaBVCcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:32:53 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:52024 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaBVCcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:32:51 -0500
Message-ID: <53080C55.3070001@prisktech.co.nz>
Date: Sat, 22 Feb 2014 15:32:53 +1300
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Alistair Popple <alistair@popple.id.au>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 4/7] ECHI Platform: Merge ppc-of EHCI driver into the
 ehci-platform driver
References: <20140221114803.GB8783@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140221114803.GB8783@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22/02/14 00:48, Mark Rutland wrote:
> [Adding Tony Prisk to Cc]
>
> On Fri, Feb 21, 2014 at 06:31:30AM +0000, Alistair Popple wrote:
>> Currently the ppc-of driver uses the compatibility string
>> "usb-ehci". This means platforms that use device-tree and implement an
>> EHCI compatible interface have to either use the ppc-of driver or add
>> a compatible line to the ehci-platform driver. It would be more
>> appropriate for the platform driver to be compatible with "usb-ehci"
>> as non-powerpc platforms are also beginning to utilise device-tree.
>>
>> This patch merges the device tree property parsing from ehci-ppc-of
>> into the platform driver and adds a "usb-ehci" compatibility
>> string. The existing ehci-ppc-of driver is removed and the 440EPX
>> specific quirks are added to the ehci-platform driver.
>>
>> Signed-off-by: Alistair Popple <alistair@popple.id.au>
>> ---
>>   drivers/usb/host/Kconfig         |    7 +-
>>   drivers/usb/host/ehci-hcd.c      |    5 -
>>   drivers/usb/host/ehci-platform.c |   87 +++++++++++++-
>>   drivers/usb/host/ehci-ppc-of.c   |  238 --------------------------------------
>>   4 files changed, 89 insertions(+), 248 deletions(-)
>>   delete mode 100644 drivers/usb/host/ehci-ppc-of.c
> Please use of_property_read_bool for these.
>
> This driver already handles "via,vt8500-ehci" and "wm,prizm-ehci" which
> aren't documented to handle these properties, but now gain support for
> them. It might be worth unifying the binding documents if there's
> nothing special about those two host controllers.
>
> We seem to have two binding documents for "via,vt8500-ehci", so some
> cleanup is definitely in order.
>
> Tony, you seem to have written both documents judging by 95e9fd10f06c
> and 8ad551d150e3. Do you have any issue with merging both of these into
> a common usb-ehci document?
......
> Cheers,
> Mark.

I'm not sure how we ended up with two bindings for the driver anyway. I 
think this was an error on my part somewhere.

None of the in-tree dts files use "wm,prizm-ehci".

I have no issue with merging all the documentation into a single 
usb-ehci binding.

Regards
Tony Prisk
