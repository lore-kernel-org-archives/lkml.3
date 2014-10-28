Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbaJ1HJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:09:33 -0400
Received: from vif1-retry101.mer-nm.internl.net ([217.149.192.107]:53306 "EHLO
	retry101.mer-nm.internl.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758747AbaJ1HJQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:09:16 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 03:09:16 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <544F3FC3.3040106@topic.nl>
Date: Tue, 28 Oct 2014 08:03:31 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@kernel.org>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>
Subject: Re: [PATCH v4] Add LTC2941/LTC2943 Battery Gauge Driver
References: <1412748300-3915-1-git-send-email-mike.looijmans@topic.nl> <1414067918-6688-1-git-send-email-mike.looijmans@topic.nl> <20141027163842.GB20765@earth.universe>
In-Reply-To: <20141027163842.GB20765@earth.universe>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 10/27/2014 05:38 PM, Sebastian Reichel wrote:
> Hi,
>
> On Thu, Oct 23, 2014 at 02:38:38PM +0200, Mike Looijmans wrote:
>> Both the LTC2941 and LTC2943 measure battery capacity.
>> The LTC2943 is compatible with the LTC2941, it adds voltage and
>> temperature monitoring, and uses a slightly different conversion
>> formula for the charge counter.
>>
>> To avoid confusion with e.g. the LTC2945, the driver is called
>> LTC2941 instead of LTC294X.
>>
>> v2: Fix units of measurement: uV, uA and centidegrees.
>> v3: Correctly set configuration register. Allow negative values
>>      for the sense resistor.
>> v4: Run checkpatch.pl and fix all errors and warnings.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>> ---
>> [...]
>>
>> +	np = of_node_get(client->dev.of_node);
>> +
>> +	/* r_sense can be negative, when sense+ is connected to the battery
>> +	 * instead of the sense-. This results in reversed measurements. */
>> +	ret = of_property_read_u32(np, "resistor-sense", &r_sense);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev,
>> +			"Could not find resistor-sense in devicetree\n");
>> +		goto fail_name;
>> +	}
>> +	info->r_sense = r_sense;
>> +
>> +	ret = of_property_read_u32(np, "prescaler-exponent", &prescaler_exp);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev,
>> +			"PrescalerExponent not in devicetree, assume max\n");
>> +		prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
>> +	}
>
> The device tree properties are not documented. Please document them
> in a separate patch and Cc devicetree binding maintainers.
>
> Apart from that the properties should be vendor prefixed (e.g.
> "lltc,resistor-sense").

Thanks for your feedback. I will post the requested changes asap.





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

