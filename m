Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaKCRId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:08:33 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:60375 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaKCRIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:08:31 -0500
MIME-Version: 1.0
In-Reply-To: <20141103101516.GA29621@leverpostej>
References: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141103101516.GA29621@leverpostej>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 3 Nov 2014 10:07:53 -0700
Message-ID: <CAErSpo4pFCie-+fjRvyERMJuPxCV9DwX8uMWGO7UU=bNLdOi7A@mail.gmail.com>
Subject: Re: [PATCH] of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended'
 text
To: Mark Rutland <mark.rutland@arm.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 3:15 AM, Mark Rutland <mark.rutland@arm.com> wrote:
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
>> CC: stable@vger.kernel.org    # v3.13+
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
>>       interrupts-extended = <&intc1 5 1>, <&intc2 1 0>;
>>
>> -A device node may contain either "interrupts" or "interrupts-extended", but not
>> -both. If both properties are present, then the operating system should log an
>> -error and use only the data in "interrupts".
>
> Why not update the binding to explain that interrupts-extended is
> typically preferred?

I'm only trying to fix the contradictory text.  It's fine with me if
somebody wants to go farther and prefer interrupts-extended (though it
does look like "interrupts" will be more concise for machines with a
single interrupt controller).

Bjorn
