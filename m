Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3KSRGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:06:11 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15644 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3KSRGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:06:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Nov 2013 09:04:12 -0800
Message-ID: <528B9A7F.1040504@nvidia.com>
Date: Tue, 19 Nov 2013 12:06:07 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Bernie Thompson <bhthompson@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH 1/3] mfd: cros ec: spi: Add delay for raising CS
References: <1384770649-8593-1-git-send-email-treding@nvidia.com> <20131118114810.GE30853@e106331-lin.cambridge.arm.com> <20131119084223.GC31504@ulmo.nvidia.com>
In-Reply-To: <20131119084223.GC31504@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 3:42 AM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Nov 18, 2013 at 11:48:10AM +0000, Mark Rutland wrote:
>> On Mon, Nov 18, 2013 at 10:30:47AM +0000, Thierry Reding wrote:
>>> From: Rhyland Klein <rklein@nvidia.com>
>>>
>>> The EC has specific timing it requires. Add support for an optional delay
>>> after raising CS to fix timing issues. This is configurable based on
>>> a DT property "google,cros-ec-spi-msg-delay".
>>>
>>> If this property isn't set, then no delay will be added. However, if set
>>> it will cause a delay equal to the value passed to it to be inserted at
>>> the end of a transaction.
>>>
>>> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
>>> Reviewed-by: Bernie Thompson <bhthompson@chromium.org>
>>> Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>>> ---
>>>  Documentation/devicetree/bindings/mfd/cros-ec.txt |  4 +++
>>>  drivers/mfd/cros_ec_spi.c                         | 30 +++++++++++++++++++++++
>>>  2 files changed, 34 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/mfd/cros-ec.txt b/Documentation/devicetree/bindings/mfd/cros-ec.txt
>>> index 5f229c5f6da9..fb3034a87ae0 100644
>>> --- a/Documentation/devicetree/bindings/mfd/cros-ec.txt
>>> +++ b/Documentation/devicetree/bindings/mfd/cros-ec.txt
>>> @@ -17,6 +17,10 @@ Required properties (SPI):
>>>  - compatible: "google,cros-ec-spi"
>>>  - reg: SPI chip select
>>>  
>>> +Optional properties (SPI):
>>> +- google,cros-ec-spi-msg-delay: This property is how long of a delay, in usecs,
>>> +  to use on the last transfer of a message, to force time between transactions.
>>> +
>>
>> Lose the "This property is", that's obvious from the structure of the
>> document.
> 
> Will do.
> 
>> It would be nice to have an explanation in the binding document as to
>> _why_ you might want to do this (e.g. the HW expects the rising edge to
>> come some number of uS after the data, if it comes too early it
>> explodes).
> 
> From what I can tell, this might differ on the exact variant of the EC,
> but generally it seems that when the interval between two transactions
> isn't long enough the EC won't be able to respond properly in time and
> cause subsequent transactions to hang. Perhaps Rhyland, Bernie or Andrew
> are more familiar with the details and therefore can provide a better or
> more accurate explanation.

I believe this explanation is correct. As I recall, I think adding this
delay helped stabilize communication with the EC, where before sometimes
transactions would time out.

-rhyland

> 
>> Otherwise this looks fine to me.
> 
> Thanks,
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 


-- 
nvpublic
