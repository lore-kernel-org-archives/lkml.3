Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3C1UTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:19:09 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:59961 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3C1UTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:19:07 -0400
Message-ID: <5154A5B5.7@gmail.com>
Date: Thu, 28 Mar 2013 21:19:01 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: fix Dove cpu type from V7 to PJ4
References: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130328170654.GX13280@titan.lakedaemon.net> <20130328181425.GE3368@n2100.arm.linux.org.uk>
In-Reply-To: <20130328181425.GE3368@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 07:14 PM, Russell King - ARM Linux wrote:
> On Thu, Mar 28, 2013 at 01:06:54PM -0400, Jason Cooper wrote:
>> On Sat, Mar 23, 2013 at 04:06:51PM +0100, Sebastian Hesselbarth wrote:
>>> The CPU used in Marvell Dove SoCs is a PJ4 Sheeva core. Using
>>> CONFIG_CPU_PJ4 instead of CONFIG_CPU_V7 will also allow to enable
>>> iWMMXt extensions on Dove.
>>>
>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>> ---
>>> Cc: Russell King<linux@arm.linux.org.uk>
>>> Cc: Jason Cooper<jason@lakedaemon.net>
>>> Cc: Andrew Lunn<andrew@lunn.ch>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>   arch/arm/Kconfig |    2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Hmmm, I'm getting (with dove_defconfig):
>>
>> arch/arm/kernel/built-in.o: In function `iwmmxt_do':
>> /.../arch/arm/kernel/pj4-cp0.c:36: undefined reference to `iwmmxt_task_release'
>> /.../arch/arm/kernel/pj4-cp0.c:40: undefined reference to `iwmmxt_task_switch'
>> make: *** [vmlinux] Error 1
>
> Looks to me like PJ4 IWMMXT support wasn't properly tested out when it
> was submitted - it's possible to end up with pj4-cp0.c built without
> the IWMMXT code that it depends on being built...

Russel, Jason,

do we force iWMMXt on CPU_PJ4 or should there be some #ifdef'ery if 
IWMMXT is not selected?

Sebastian
