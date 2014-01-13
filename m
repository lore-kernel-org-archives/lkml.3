Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaAMGXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:23:42 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:34415 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaAMGXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:23:40 -0500
Message-ID: <52D38668.7090807@codethink.co.uk>
Date: Mon, 13 Jan 2014 06:23:36 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
References: <1389367095-7760-1-git-send-email-ben.dooks@codethink.co.uk> <20140113003014.GG15296@verge.net.au>
In-Reply-To: <20140113003014.GG15296@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/14 00:30, Simon Horman wrote:
> On Fri, Jan 10, 2014 at 03:18:15PM +0000, Ben Dooks wrote:
>> If the kernel is built to support multi-arm configurmation with shmobile
>> support built in, then the drivers/sh is not built. This contains drivers
>> that are essential to devices support by that configuration, including the
>> PM runtime code in drivers/sh/pm_runtime.c (which implicitly enables the
>> bus clocks for all devices).
>>
>> If CONFIG_ARCH_SHMOBILE_MULTI then build the drivers/sh directory,
>> but ensure that bits that may conflict (drivers/sh/clk if the common
>> clock framework is not enabled) are built.
>>
>> The ARCH_SHMOBILE_MULTI was added by efacfce5f8a ("ARM: shmobile: Introduce
>> ARCH_SHMOBILE_MULTI") but this has only just recently been found due to
>> building device-tree only kernels.
>>
>> Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
>> Cc: Linus SH list <linux-sh@vger.kernel.org>
>> Cc: Simon Horman <horms@verge.net.au>
>> Cc: Magnus Damm <magnus.damm@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>   drivers/Makefile    | 1 +
>>   drivers/sh/Makefile | 3 +++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 8e3b8b0..abc4744 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -118,6 +118,7 @@ obj-$(CONFIG_SGI_SN)		+= sn/
>>   obj-y				+= firmware/
>>   obj-$(CONFIG_CRYPTO)		+= crypto/
>>   obj-$(CONFIG_SUPERH)		+= sh/
>> +obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= sh/
>>   obj-$(CONFIG_ARCH_SHMOBILE_LEGACY)	+= sh/
>
> Can't we just do the following?

I think this is probably a better fix. I am wondering what the original
logic of not doing this was.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
