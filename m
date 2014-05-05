Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaEEVi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:38:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60655 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706AbaEEViZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:38:25 -0400
Message-ID: <536804B0.6050707@ti.com>
Date: Mon, 5 May 2014 16:37:52 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 RFC 08/15] hwspinlock/core: add support for base id
 in DT
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>	<1398904476-26200-9-git-send-email-s-anna@ti.com> <CAL_JsqJW1pqUjQ3DQrppO5n=MmpFOhCyU2zkSzA9s9TpYbq3CA@mail.gmail.com>
In-Reply-To: <CAL_JsqJW1pqUjQ3DQrppO5n=MmpFOhCyU2zkSzA9s9TpYbq3CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 05/05/2014 03:37 PM, Rob Herring wrote:
> On Wed, Apr 30, 2014 at 7:34 PM, Suman Anna <s-anna@ti.com> wrote:
>> The HwSpinlock core requires a base id for registering a bank
>> of hwspinlocks. This base id needs to be unique across multiple
>> IP instances of a hwspinlock device, so that each hwlock can be
>> represented uniquely in a system.
>>
>> Support has been added to represent this in DT through a common
>> property 'hwlock-base-id', and retrieve the value through a core
>> OF helper function, of_hwspin_lock_get_base_id(). The representation
>> in DT provides a uniform way of assigning a fixed base value for a
>> hwspinlock device across different SoCs.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> ---
>>  Documentation/devicetree/bindings/hwlock/hwlock.txt |  6 ++++++
>>  drivers/hwspinlock/hwspinlock_core.c                | 21 +++++++++++++++++++++
>>  include/linux/hwspinlock.h                          |  1 +
>>  3 files changed, 28 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>> index 32381cc..d538a9b 100644
>> --- a/Documentation/devicetree/bindings/hwlock/hwlock.txt
>> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
>> @@ -18,6 +18,12 @@ Common properties:
>>                         property is needed on hwlock devices, where the number
>>                         of supported locks within a hwlock device cannot be
>>                         read from a register.
>> +- hwlock-base-id:      An unique base Id for the locks for a particular hwlock
>> +                       device. This property is mandatory ONLY if a SoC has
>> +                       several hwlock devices.
>> +
>> +                       See documentation on struct hwspinlock_pdata in
>> +                       include/linux/hwspinlock.h for more details.
> 
> The documentation cannot refer to kernel files. 

OK, good to know. There are couple of such existing references, so
didn't think it was an issue. I will fold this patch and remove the
kernel reference if this property is ok to add.

> Generally, creating a
> global number space like this would not be accepted, but I don't
> really have any better idea here.
> 
> Please put all binding docs in 1 patch and copy all the DT binding maintainers.

I have deliberately put these in separate patches (as RFC) as there
doesn't seem to be a consensus on this. I had added this originally,
dropped it and brought it back again based on discussion on the previous
version. Intention was either to fold into the original patch if
accepted or drop them and revisit later.

regards
Suman
