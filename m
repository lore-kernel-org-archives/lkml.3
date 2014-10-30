Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbaJ3Grw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:47:52 -0400
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:40351 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230AbaJ3Grs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:47:48 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <5451DF10.7030605@topic.nl>
Date: Thu, 30 Oct 2014 07:47:44 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add ltc3562 voltage regulator driver
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl> <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <20141029123005.GH18557@sirena.org.uk>
In-Reply-To: <20141029123005.GH18557@sirena.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 10/29/2014 01:30 PM, Mark Brown wrote:
> On Wed, Oct 29, 2014 at 09:16:00AM +0100, Mike Looijmans wrote:
>
>> +	if (!status->voltage_set) {
>> +		if (of_property_read_u32(dev->dev.of_node,
>> +			"ltc3562-default-voltage", &v_default) == 0) {
>
> A couple of problems here:
>
>   - This contains DT code but no DT bindings documentation; the binding
>     documentation is mandatory for any new bindings.

Should I submit a new patch to add the DT bindings and CC to the dt mailing 
list, or do you want it included in this patch? I was basically waiting for 
feedback on the driver first.

>   - It's not obvious why a "default voltage" property would be device
>     specific - what is this for and why is it being added in an
>     individual device driver?

As for the "why" part: The default is used when there isn't a consumer 
available. It'll typically be combined with "always-on". When the output is 
used for say an MMC card, the consumer will ask for a specific voltage. When 
used to regulate the IO voltage of an FPGA bank (as is the case on our board), 
there isn't a single consumer to request a particular voltage, but the min and 
max will represent the range that the IO banks support (e.g. 1v8..3v3 or 
1v2..1v8), because selecting voltages outside this range may damage the FPGA 
hardware. This allows a devicetree overlay to specify a different value for a 
different board or application, while still being able to restrict the range 
to what the hardware connected to the regulator supports.

The "default voltage" may not be device specific, but regulator.txt doesn't 
have a property that describes what we needed here, because we can't get away 
with specifying min=max as fixed-regulator does. We also cannot assume that 
default=min or default=max, because that might harm hardware connected to the 
other side of the IO bank.

I noticed after rebasing to mainline that there is now also a driver for a 
similar chip (similar in function, that is), the ltc3589, which requires 
similar properties like the resistor dividers. I think it would be good to use 
similar names in the ltc3562 driver. I'll do that first and submit a v2 patch, 
along with the DT description.

Thank you for your feedback,
Mike.



Met vriendelijke groet / kind regards,

Mike Looijmans
System Expert


TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

