Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaIXOvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:51:09 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43078 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaIXOvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:51:04 -0400
Message-ID: <5422DA54.4020806@linaro.org>
Date: Wed, 24 Sep 2014 15:51:00 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: fdt: fix memory range check
References: <1411466349-14166-1-git-send-email-srinivas.kandagatla@linaro.org> <20140924143844.B2218C40738@trevor.secretlab.ca>
In-Reply-To: <20140924143844.B2218C40738@trevor.secretlab.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/09/14 15:38, Grant Likely wrote:
>> --- a/drivers/of/fdt.c
>> >+++ b/drivers/of/fdt.c
>> >@@ -937,7 +937,7 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>> >  		return;
>> >  	}
>> >
>> >-	if (base + size > MAX_PHYS_ADDR) {
>> >+	if (base + size - 1 > MAX_PHYS_ADDR) {
>> >  		pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
>> >  				ULONG_MAX, base + size);
>> >  		size = MAX_PHYS_ADDR - base;
> By that logic, the above two lines need to be repaired also:
Thanks for fixing this too.
>
> 		pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
> 				MAX_PHYS_ADDR + 1, base + size);

I think the first argument should be printed in 0x%llx format as there 
would be a 32bit overflow for MAX_PHYS_ADDR + 1.

> 		size = MAX_PHYS_ADDR - base + 1;
>
> I've fixed it up and applied, thanks.

--srini
