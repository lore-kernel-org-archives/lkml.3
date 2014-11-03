Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaKCSGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:06:45 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64311 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaKCSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:06:39 -0500
Message-ID: <5457C40F.8050407@gmail.com>
Date: Mon, 03 Nov 2014 10:06:07 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended'
 text
References: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com> <20141103101516.GA29621@leverpostej>
In-Reply-To: <20141103101516.GA29621@leverpostej>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 02:15 AM, Mark Rutland wrote:
> On Sat, Nov 01, 2014 at 11:35:31PM +0000, Bjorn Helgaas wrote:
>> a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property
>> first") updated the description to say that:
>>
>>   - Both 'interrupts' and 'interrupts-extended' may be present
>>   - Software should prefer 'interrupts-extended'
>>   - Software that doesn't comprehend 'interrupts-extended' may use
>>     'interrupts'
>>
>> But there is still a paragraph at the end that prohibits having both and
>> says 'interrupts' should be preferred.
>>
>> Remove the contradictory text.
>>
>> Fixes: a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property first")
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> CC: stable@vger.kernel.org	# v3.13+
>> ---
>>  .../bindings/interrupt-controller/interrupts.txt   |    4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
>> index ce6a1a072028..8a3c40829899 100644
>> --- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
>> +++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
>> @@ -30,10 +30,6 @@ should only be used when a device has multiple interrupt parents.
>>    Example:
>>  	interrupts-extended = <&intc1 5 1>, <&intc2 1 0>;
>>  
>> -A device node may contain either "interrupts" or "interrupts-extended", but not
>> -both. If both properties are present, then the operating system should log an
>> -error and use only the data in "interrupts".
> 
> Why not update the binding to explain that interrupts-extended is
> typically preferred?

Does not the following:

"Nodes that describe devices which generate interrupts must contain an
"interrupts" property, an "interrupts-extended" property, or both. If
both are
present, the latter should take precedence; the former may be provided
simply
for compatibility with software that does not recognize the latter."

already makes it clear that 'interrupts-extended' is the preferred way
to represent interrupts?
--
Florian
