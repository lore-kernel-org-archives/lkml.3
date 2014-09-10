Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaIJIZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:25:16 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:19307 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIJIZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:25:13 -0400
Message-ID: <54100AE5.6050401@imgtec.com>
Date: Wed, 10 Sep 2014 09:25:09 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <linux-mips@linux-mips.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH linux-next] MIPS: ioctls: Add missing TIOC{S,G}RS485 definitions
References: <1410263575-26720-1-git-send-email-markos.chandras@imgtec.com> <20140909191736.GA7467@kroah.com>
In-Reply-To: <20140909191736.GA7467@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 08:17 PM, Greg KH wrote:
> On Tue, Sep 09, 2014 at 12:52:55PM +0100, Markos Chandras wrote:
>> Commit e676253b19b2d269cccf67fdb1592120a0cd0676
>> (serial/8250: Add support for RS485 IOCTLs) added cases for the
>> TIOC{S,G}RS485 commands but this broke the build for MIPS:
>>
>> drivers/tty/serial/8250/8250_core.c: In function 'serial8250_ioctl':
>> drivers/tty/serial/8250/8250_core.c:2874:7: error: 'TIOCSRS485' undeclared
>> (first use in this function)
>> drivers/tty/serial/8250/8250_core.c:2886:7: error: 'TIOCGRS485' undeclared
>> (first use in this function)
>>
>> This patch adds these missing definitions
>>
>> Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> Cc: <linux-next@vger.kernel.org>
>> Cc: <linux-kernel@vger.kernel.org>
>> Cc: <linux-serial@vger.kernel.org>
>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>> ---
>>  arch/mips/include/uapi/asm/ioctls.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/mips/include/uapi/asm/ioctls.h b/arch/mips/include/uapi/asm/ioctls.h
>> index b1e637757fe3..34050cb6b631 100644
>> --- a/arch/mips/include/uapi/asm/ioctls.h
>> +++ b/arch/mips/include/uapi/asm/ioctls.h
>> @@ -76,6 +76,8 @@
>>  
>>  #define TIOCSBRK	0x5427	/* BSD compatibility */
>>  #define TIOCCBRK	0x5428	/* BSD compatibility */
>> +#define TIOCGRS485	0x542E
>> +#define TIOCSRS485	0x542F
> 
> Any reason you aren't using the _IOR() type macros here?
> 
> thanks,
> 
> greg k-h
> 
Hi Greg,

Not really. I am being consistent with what
include/uapi/asm-generic/ioctls.h is using, and with the xtensa patch
that was posted yesterday

https://lkml.org/lkml/2014/9/9/27

-- 
markos
