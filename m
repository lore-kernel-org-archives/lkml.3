Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbaJ3KaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:30:03 -0400
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:42604 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758662AbaJ3KaA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:30:00 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <5452131F.9000307@topic.nl>
Date: Thu, 30 Oct 2014 11:29:51 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add ltc3562 voltage regulator driver
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl> <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <20141029123005.GH18557@sirena.org.uk> <5451DF10.7030605@topic.nl> <20141030101555.GT18557@sirena.org.uk>
In-Reply-To: <20141030101555.GT18557@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 10/30/2014 11:15 AM, Mark Brown wrote:
> On Thu, Oct 30, 2014 at 07:47:44AM +0100, Mike Looijmans wrote:
>> ﻿On 10/29/2014 01:30 PM, Mark Brown wrote:
>
>>> A couple of problems here:
>
>>>   - This contains DT code but no DT bindings documentation; the binding
>>>     documentation is mandatory for any new bindings.
>
>> Should I submit a new patch to add the DT bindings and CC to the dt mailing
>> list, or do you want it included in this patch? I was basically waiting for
>> feedback on the driver first.
>
> I'm not going to review a driver with bindings without those bindings
> being documented, it's a well documented requirement and apart from
> anything else it's not really possible to review the code that manages
> the bindings without seeing the bindings.
>
>> The "default voltage" may not be device specific, but regulator.txt doesn't
>> have a property that describes what we needed here, because we can't get
>> away with specifying min=max as fixed-regulator does. We also cannot assume
>> that default=min or default=max, because that might harm hardware connected
>> to the other side of the IO bank.
>
> No, if you need a generic property add it in the generic code rather
> than just hacking a device specific property into your driver.

So I should add "regulator-default-voltage" to the generic code? That would 
indeed be better than trying to do it into this driver.

But would that need a separate patch for regulator core to add the property?

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

