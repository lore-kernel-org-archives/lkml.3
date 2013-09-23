Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3IWWBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:01:50 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16260 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3IWWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:01:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Sep 2013 14:58:14 -0700
Message-ID: <5240BA4A.4010007@nvidia.com>
Date: Mon, 23 Sep 2013 18:01:46 -0400
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
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com> <5240B85D.3050803@wwwdotorg.org>
In-Reply-To: <5240B85D.3050803@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2013 5:53 PM, Stephen Warren wrote:
> On 09/19/2013 10:18 AM, Rhyland Klein wrote:
>> Adding driver support for bq24735 charger chipset.
> 
>> diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
> 
>> +Optional properties :
>> + - ti,ac-detect: This gpio is optionally used to read the ac adapter
>> +   presence.
> 
> GPIO property names ought to end in "-gpios", i.e. "ti,ac-detect-gpios".

V3 (still in the process of finishing up and testing, will have this change.

> 
>> + - ti,charge-current : Used to control and set the charging current. This value
>> +   must follow the below guidelines:
>> +	bit 0 - 5:	Not used
>> +	bit 6:		1 = Adds 64mA of charger current
>> +	bit 7:		1 = Adds 128mA of charger current
>> +	bit 8:		1 = Adds 256mA of charger current
>> +	bit 9:		1 = Adds 512mA of charger current
>> +	bit 10:		1 = Adds 1024mA of charger current
>> +	bit 11:		1 = Adds 2048mA of charger current
>> +	bit 12:		1 = Adds 4096mA of charger current
>> +	bit 13 - 15:	Not used
> 
> That's a little odd. Why not just put the number of mA directly into the
> property unshifted?

This is how the hw register is defined, its the literal number of mA.
This is cleaned up in the upcoming revision.

> 
>> +   Setting the value to < 128mA or > 8.128A terminates charging.
> 
> "terminates charging" is a driver action, not a description of HW. It's
> fine to say that what min/max value should be specified in the property
> for it to be valid, but not what action SW should take in response to that.

This isn't sw. This is defined in the HW documentation as to what
happens if an invalid value is used.

> 
> Those same two comments apply to other properties too.
> 
>> + - ti,input-current:	Used to control and set the charger input current. This
>> +   value must follow the below guidelines:
> 
> What if this value is inconsistent with the charger's power consumption
> derived from the other two properties? Is it really necessary to include
> this property in the DT and hence create the potential for mismatch?
> 

This is a field which can be set in the device's registers. I think it
is being used in our downstream kernel. I maintained support for these 3
fields for the sake of completely defining the dt binding up front.

-rhyland


-- 
nvpublic
