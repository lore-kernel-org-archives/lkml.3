Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3IIXzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:55:51 -0400
Received: from mailout.micron.com ([137.201.242.129]:54051 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3IIXzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:55:49 -0400
Message-ID: <522E5FD5.40603@micron.com>
Date: Mon, 9 Sep 2013 16:55:01 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: powerpc allmodconfig build broken due to commit 15863ff3b (powerpc:
 Make chip-id information available to userspace)
References: <522D163E.80106@roeck-us.net>
In-Reply-To: <522D163E.80106@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20136.005
X-TM-AS-Result: No--12.091900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2013 5:28 PM, Guenter Roeck wrote:
> Hi all,
>
> powerpc allmodconfig build on the latest upstream kernel results in:
>
> ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!
>
> This is due to commit 15863ff3b (powerpc: Make chip-id information 
> available to userspace).
> Not surprising, as cpu_to_chip_id() is not exported.
>
Apart from the above error, I have a concern on the patch, purely based on the commit message.
(to be honest, I am not familiar with the ppc architecture)

Commit message of 15863ff3b has the following text.

******************
So far "/sys/devices/system/cpu/cpuX/topology/physical_package_id"
was always default (-1) on ppc64 architecture.

Now, some systems have an ibm,chip-id property in the cpu nodes in
the device tree. On these systems, we now use this information to
display physical_package_id
******************

Shouldn't the new definition of "topology_physical_package_id" apply only to those systems supporting ibm,chip-id property?


> Reverting this commit fixes the problem. Any good idea how to fix it 
> for real ?
>
> Guenter
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

