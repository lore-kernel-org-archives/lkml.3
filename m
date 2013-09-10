Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3IJBTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:19:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50632 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3IJBTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:19:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522E7380.3090701@roeck-us.net>
Date: Mon, 09 Sep 2013 18:18:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: powerpc allmodconfig build broken due to commit 15863ff3b (powerpc:
 Make chip-id information available to userspace)
References: <522D163E.80106@roeck-us.net> <522E5FD5.40603@micron.com>
In-Reply-To: <522E5FD5.40603@micron.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 04:55 PM, Asai Thambi S P wrote:
> On 09/08/2013 5:28 PM, Guenter Roeck wrote:
>> Hi all,
>>
>> powerpc allmodconfig build on the latest upstream kernel results in:
>>
>> ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!
>>
>> This is due to commit 15863ff3b (powerpc: Make chip-id information available to userspace).
>> Not surprising, as cpu_to_chip_id() is not exported.
>>
> Apart from the above error, I have a concern on the patch, purely based on the commit message.
> (to be honest, I am not familiar with the ppc architecture)
>
> Commit message of 15863ff3b has the following text.
>
> ******************
> So far "/sys/devices/system/cpu/cpuX/topology/physical_package_id"
> was always default (-1) on ppc64 architecture.
>
> Now, some systems have an ibm,chip-id property in the cpu nodes in
> the device tree. On these systems, we now use this information to
> display physical_package_id
> ******************
>
> Shouldn't the new definition of "topology_physical_package_id" apply only to those systems supporting ibm,chip-id property?
>
Looking into the code, I think that is what it does. For other platforms
(ie if there is no ibm,chip-id property) it still returns -1.

Question for the fix is what path to take to fix the problem.
Exporting cpu_to_chip_id() might be the easiest solution. Other
platforms export the respective data, so it should not be a problem.

I might submit a patch and see where it goes.

Guenter

>
>> Reverting this commit fixes the problem. Any good idea how to fix it for real ?
>>
>> Guenter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>

