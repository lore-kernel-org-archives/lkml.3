Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3IWWFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:05:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39694 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IWWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:05:34 -0400
Message-ID: <5240BB2A.8060705@wwwdotorg.org>
Date: Mon, 23 Sep 2013 16:05:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Patch V2] drivers: power: Add support for bq24735 charger
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com> <5240B85D.3050803@wwwdotorg.org> <5240BA4A.4010007@nvidia.com>
In-Reply-To: <5240BA4A.4010007@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 04:01 PM, Rhyland Klein wrote:
> On 9/23/2013 5:53 PM, Stephen Warren wrote:
>> On 09/19/2013 10:18 AM, Rhyland Klein wrote:
>>> Adding driver support for bq24735 charger chipset.
>>
>>> diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt

>>> + - ti,charge-current : Used to control and set the charging current. This value
>>> +   must follow the below guidelines:
>>> +	bit 0 - 5:	Not used
>>> +	bit 6:		1 = Adds 64mA of charger current
>>> +	bit 7:		1 = Adds 128mA of charger current
>>> +	bit 8:		1 = Adds 256mA of charger current
>>> +	bit 9:		1 = Adds 512mA of charger current
>>> +	bit 10:		1 = Adds 1024mA of charger current
>>> +	bit 11:		1 = Adds 2048mA of charger current
>>> +	bit 12:		1 = Adds 4096mA of charger current
>>> +	bit 13 - 15:	Not used
>>
>> That's a little odd. Why not just put the number of mA directly into the
>> property unshifted?
> 
> This is how the hw register is defined, its the literal number of mA.
> This is cleaned up in the upcoming revision.

OK. If you still want to use the raw register encoding, which seems
reasonable, why not just say:

ti,charge-current: Value for charge current register as described in the
HW documentation.

>>> +   Setting the value to < 128mA or > 8.128A terminates charging.
>>
>> "terminates charging" is a driver action, not a description of HW. It's
>> fine to say that what min/max value should be specified in the property
>> for it to be valid, but not what action SW should take in response to that.
> 
> This isn't sw. This is defined in the HW documentation as to what
> happens if an invalid value is used.

OK, if the HW documentation already says that, I don't see the need for
the DT binding to also say it; I would suggest just removing that text.
