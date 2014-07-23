Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbaGWLh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:37:27 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41644 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaGWLhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:37:24 -0400
Message-ID: <53CF9E66.9050101@gmail.com>
Date: Wed, 23 Jul 2014 19:37:10 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, msalter@redhat.com,
        Guenter Roeck <linux@roeck-us.net>, linux-pwm@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        arnd@arndb.de, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <53C47725.8000005@gmail.com> <53C47B76.4080306@roeck-us.net> <53C47FB7.6080304@gmail.com> <53C53CE1.4090803@gmail.com> <53C7269E.4010702@gmail.com> <20140717083756.GA19686@ulmo> <53C7905D.9090003@gmail.com> <20140717091601.GF25880@mwanda> <53C7951F.6000906@gmail.com> <53CF97E2.9000906@gmail.com> <20140723113023.GT25880@mwanda>
In-Reply-To: <20140723113023.GT25880@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/23/2014 07:30 PM, Dan Carpenter wrote:
> On Wed, Jul 23, 2014 at 07:09:22PM +0800, Chen Gang wrote:
>>
>>
>> On 07/17/2014 05:19 PM, Chen Gang wrote:
>>>
>>>
>>> On 07/17/2014 05:16 PM, Dan Carpenter wrote:
>>>> On Thu, Jul 17, 2014 at 04:59:09PM +0800, Chen Gang wrote:
>>>>>>> +	return (__force void __iomem *)ERR_PTR(-ENXIO);
>>>>>>
>>>>>> There's apparently an IOMEM_ERR_PTR() for this nowadays...
>>>>>>
>>>>>
>>>>> IOMEM_ERR_PTR() is defined within "lib/devres.c", not in "./include".
>>>>> But may we move it from "lib/devres.c" to "./include/linux/err.h"?
>>>>>
>>>>> For me, I am not quite sure, it may need additional discussion, but at
>>>>> least, that will be another patch.
>>>>
>>>> Yes.  Move it there.  That is the right place.
>>>>
>>
>> Sorry for replying late about IOMEM_ERR_PTR().
>>
>> Although no objections within 2 days, for me, when move something to
>> generic header file, it is not only for future using, but also for
>> solving current issue, or it has to be suspended for waiting 'trigger'.
>>
>> So for me, the patch about IOMEM_ERR_PTR() need be suspended, until some
>> member find an issue which may be related with IOMEM_ERR_PTR(), more or
>> less.
> 
> Matthias Brugger already moved it to include/linux/io.h on Friday.
> 

OK, thank you for your work.

And for me, this 'long discussion' can be finished now (keeping current
status no touch). But if any members have additional suggestions and
ideas, still welcome to reply directly.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
