Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3IXQje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:39:34 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6638 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab3IXQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:39:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Sep 2013 09:35:56 -0700
Message-ID: <5241C041.7020208@nvidia.com>
Date: Tue, 24 Sep 2013 12:39:29 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Patch V2] drivers: power: Add support for bq24735 charger
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com> <5240B85D.3050803@wwwdotorg.org> <5240BA4A.4010007@nvidia.com> <5240BB2A.8060705@wwwdotorg.org>
In-Reply-To: <5240BB2A.8060705@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2013 6:05 PM, Stephen Warren wrote:
> On 09/23/2013 04:01 PM, Rhyland Klein wrote:
>> On 9/23/2013 5:53 PM, Stephen Warren wrote:
>>> On 09/19/2013 10:18 AM, Rhyland Klein wrote:
>>>> Adding driver support for bq24735 charger chipset.
>>>
>>>> diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
> 
>>>> + - ti,charge-current : Used to control and set the charging current. This value
>>>> +   must follow the below guidelines:
>>>> +	bit 0 - 5:	Not used
>>>> +	bit 6:		1 = Adds 64mA of charger current
>>>> +	bit 7:		1 = Adds 128mA of charger current
>>>> +	bit 8:		1 = Adds 256mA of charger current
>>>> +	bit 9:		1 = Adds 512mA of charger current
>>>> +	bit 10:		1 = Adds 1024mA of charger current
>>>> +	bit 11:		1 = Adds 2048mA of charger current
>>>> +	bit 12:		1 = Adds 4096mA of charger current
>>>> +	bit 13 - 15:	Not used
>>>
>>> That's a little odd. Why not just put the number of mA directly into the
>>> property unshifted?
>>
>> This is how the hw register is defined, its the literal number of mA.
>> This is cleaned up in the upcoming revision.
> 
> OK. If you still want to use the raw register encoding, which seems
> reasonable, why not just say:
> 
> ti,charge-current: Value for charge current register as described in the
> HW documentation.

I had written this for v3:

- ti,charge-current : Used to control and set the charging current. This
value must be between 128mA and 8.128A with a 64mA step resolution. The
POR value is 0x0000h. See spec for more details.

Do you think the range is unnecessary or is it fine?

> 
>>>> +   Setting the value to < 128mA or > 8.128A terminates charging.
>>>
>>> "terminates charging" is a driver action, not a description of HW. It's
>>> fine to say that what min/max value should be specified in the property
>>> for it to be valid, but not what action SW should take in response to that.
>>
>> This isn't sw. This is defined in the HW documentation as to what
>> happens if an invalid value is used.
> 
> OK, if the HW documentation already says that, I don't see the need for
> the DT binding to also say it; I would suggest just removing that text.
> 

Will remove in v3.

-rhyland


-- 
nvpublic
