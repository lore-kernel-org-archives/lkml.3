Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3IKGgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:36:09 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36729 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3IKGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:36:07 -0400
Message-ID: <52300F59.3070605@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 12:06:09 +0530
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: powerpc allmodconfig build broken due to commit 15863ff3b (powerpc:
 Make chip-id information available to userspace)
References: <522D163E.80106@roeck-us.net> <522E5FD5.40603@micron.com> <1378850569.4121.28.camel@pasglop> <20130910225029.GA26981@roeck-us.net>
In-Reply-To: <20130910225029.GA26981@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091117-3568-0000-0000-00000439098F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 04:20 AM, Guenter Roeck wrote:
> On Wed, Sep 11, 2013 at 08:02:49AM +1000, Benjamin Herrenschmidt wrote:
>> On Mon, 2013-09-09 at 16:55 -0700, Asai Thambi S P wrote:
>>> On 09/08/2013 5:28 PM, Guenter Roeck wrote:
>>>> Hi all,
>>>>

Guenter, Ben,

Sorry for the inconvenience. I never realized my patch could break somewhere :-(

Thanks you very much for identifying and fixing this issue. Other patch looks 
good to me.

-Vasant


>>>> powerpc allmodconfig build on the latest upstream kernel results in:
>>>>
>>>> ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!
>>>>
>>>> This is due to commit 15863ff3b (powerpc: Make chip-id information
>>>> available to userspace).
>>>> Not surprising, as cpu_to_chip_id() is not exported.
>>>>
>>> Apart from the above error, I have a concern on the patch, purely based on the commit message.
>>> (to be honest, I am not familiar with the ppc architecture)
>>>
>>> Commit message of 15863ff3b has the following text.
>>>
>>> ******************
>>> So far "/sys/devices/system/cpu/cpuX/topology/physical_package_id"
>>> was always default (-1) on ppc64 architecture.
>>>
>>> Now, some systems have an ibm,chip-id property in the cpu nodes in
>>> the device tree. On these systems, we now use this information to
>>> display physical_package_id
>>> ******************
>>>
>>> Shouldn't the new definition of "topology_physical_package_id" apply only to those systems supporting ibm,chip-id property?
>>
>> There should be no negative side effect (appart from the missing
>> EXPORT_SYMBOL of course). If the property is not found in the
>> device-tree, the new function returns -1, so it should work fine on all
>> systems.
>>
> Good. I submitted a patch doing just that yesterday or so.
> Hope you'll accept it ;).
>
> Thanks,
> Guenter
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

