Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465Ab3ICXTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:19:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44218 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3ICXTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:19:00 -0400
Message-ID: <52266E43.70102@infradead.org>
Date: Tue, 03 Sep 2013 16:18:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] of_irq.h: fix build warnings when CONFIG_OF is not enabled
References: <5224B499.4010600@infradead.org> <CAL_Jsq+82vm_vt5EpcG1zvWmL_H4KY=91tB1WH5yUhHsiM11DA@mail.gmail.com>
In-Reply-To: <CAL_Jsq+82vm_vt5EpcG1zvWmL_H4KY=91tB1WH5yUhHsiM11DA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/13 15:31, Rob Herring wrote:
> On Mon, Sep 2, 2013 at 10:54 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix build warnings when CONFIG_OF is not enabled:
> 
> It would be nice to know what arch/config you see this on.

i386 and x86_64.

> 
>> include/linux/of_irq.h:82:7: warning: 'struct device_node' declared inside parameter list [enabled by default]
>> include/linux/of_irq.h:82:7: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>> include/linux/of_irq.h:87:47: warning: 'struct device_node' declared inside parameter list [enabled by default]
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc:     Grant Likely <grant.likely@linaro.org>
>> Cc:     Rob Herring <rob.herring@calxeda.com>
>> Cc:     devicetree@vger.kernel.org
>> ---
>>  include/linux/of_irq.h |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- linux-next-20130830.orig/include/linux/of_irq.h
>> +++ linux-next-20130830/include/linux/of_irq.h
>> @@ -78,6 +78,8 @@ extern void of_irq_init(const struct of_
>>  #endif /* CONFIG_OF_IRQ */
>>
>>  #else /* !CONFIG_OF */
>> +struct device_node;
> 
> Can you move this outside of the ifdefs to minimize the amount of ifdef'ed code.

I'm build testing that change now, but it seems odd to have it there in 2 ways
when CONFIG_OF is enabled:


struct device_node;

#if defined(CONFIG_OF)

#include <linux/of.h>



will resend the patch shortly.

-- 
~Randy
