Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbbAEWbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:31:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28209 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEWbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:31:49 -0500
Message-ID: <54AB10AD.1080308@oracle.com>
Date: Mon, 05 Jan 2015 14:31:09 -0800
From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Roger Quadros <rogerq@ti.com>, tony@atomide.com, t-kristo@ti.com,
        nm@ti.com, nsekhar@ti.com, bcousson@baylibre.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, s-anna@ti.com, ssantosh@kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com> <54AA4CD4.40105@ti.com> <alpine.DEB.2.02.1501052206580.28771@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1501052206580.28771@utopia.booyaka.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/5/15 2:19 PM, Paul Walmsley wrote:
> + Santosh
>
> Hi Lokesh
>
> On Mon, 5 Jan 2015, Lokesh Vutla wrote:
>> On Saturday 03 January 2015 02:40 AM, Paul Walmsley wrote:
>>> On Thu, 18 Dec 2014, Roger Quadros wrote:
>>>
>>>> On 18/12/14 17:49, Roger Quadros wrote:
>>>>> There are quite a few hwmods that don't have sysconfig register and so
>>>>> _find_mpu_rt_port(oh) will return NULL thus preventing ready state check
>>>>> on those modules after the module is enabled.
>>>
>>> Hmm.  Any IP block that exposes registers that are accessible by the MPU
>>> should have an MPU register target port, even if there's no SYSCONFIG
>>> register.  And if an IP block doesn't have registers that are accessible
>>> from the MPU, then there shouldn't be much point to waiting for the module
>>> to become ready.
>>>
>>> Looks like the real problem is the test for oh->class->sysc before the
>>> call to _init_mpu_rt_base().  That was introduced by commit 6423d6df1440
>>> ("ARM: OMAP2+: hwmod: check for module address space during init"). It's
>>> not clear to me why that test was added, since _init_mpu_rt_base() doesn't
>>> do anything with oh->class->sysc or SYSCONFIG registers.
>> This was introduced by commit
>> 97597b962529 (ARM: OMAP2+: hwmod: Don't call _init_mpu_rt_base if no sysc)
>
> Yes, you're right.  I misread commit 6423d6df1440.
>
>> Patch description states that "there are few hwmod which doesn't have sysconfig registers and hence
>> no need to ioremap() them in early init code".
>
> The MPU register target port code doesn't only determine whether the
> hwmod code should map the IP block's address space.  It also determines
> whether or not the hwmod code needs to wait for the IP block to become
> ready after being enabled, so register accesses by non-hwmod code can
> succeed.
>
IIRC, Yes the intention was to skip the ioremap o.w there were some 
crashes seen. I am fine if that check is actually moved closer
to iormap as it should have been first place.

Regards,
Santosh
seen
