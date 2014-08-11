Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaHKQZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:25:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61750 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaHKQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:25:10 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E8EE64.8020607@roeck-us.net>
Date: Mon, 11 Aug 2014 09:25:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
References: <1407561732-817-1-git-send-email-linux@roeck-us.net> <20140811102052.6d9c28cb@canb.auug.org.au>
In-Reply-To: <20140811102052.6d9c28cb@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 05:20 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Fri,  8 Aug 2014 22:22:12 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Once again, we see
>>
>> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>> arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
>> arch/powerpc/kernel/exceptions-64s.S:866: Error: attempt to move .org backwards
>> arch/powerpc/kernel/exceptions-64s.S:890: Error: attempt to move .org backwards
>>
>> when compiling ppc:allmodconfig.
>>
>> This time the problem has been caused by to commit 0869b6fd209bda
>> ("powerpc/book3s: Add basic infrastructure to handle HMI in Linux"),
>> which adds functions hmi_exception_early and hmi_exception_after_realmode
>> into a critical (size-limited) code area, even though that does not appear
>> to be necessary.
>>
>> Move those functions to a non-critical area of the file.
>>
>> Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> Compile tested with all ppc configurations.
>> The reported checkpatch error appears to be a false positive.
>
> Thanks.
>
> I have added that to my fixes tree for today.
>
Thanks!

Guenter

