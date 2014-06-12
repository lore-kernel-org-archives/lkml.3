Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaFLNjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:39:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43485 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866AbaFLNjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:39:52 -0400
Message-ID: <5399AD1E.9010801@ti.com>
Date: Thu, 12 Jun 2014 19:07:34 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <tglx@linutronix.de>
Subject: Re: [PATCH V2 11/19] irqchip: crossbar: fix memory leak incase of
 invalid entry
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com> <1402574007-13987-12-git-send-email-r.sricharan@ti.com> <20140612132023.GX8664@titan.lakedaemon.net>
In-Reply-To: <20140612132023.GX8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thursday 12 June 2014 06:50 PM, Jason Cooper wrote:
> On Thu, Jun 12, 2014 at 05:23:19PM +0530, Sricharan R wrote:
>> From: Nishanth Menon <nm@ti.com>
>>
>> When the provided unused skip list entry is greater than max irqs
>> possible, we go to err3, but we fail to free register_offsets,
>> should have returned to err4 instead which ensures that allocated
> 
> s/returned/jumped/
 ok, will correct.

> 
>> register_offsets are freed as well.
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>>  drivers/irqchip/irq-crossbar.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
>> index 42a2e62..fea3e5d 100644
>> --- a/drivers/irqchip/irq-crossbar.c
>> +++ b/drivers/irqchip/irq-crossbar.c
>> @@ -225,7 +225,7 @@ static int __init crossbar_of_init(struct device_node *node,
>>  
>>  			if (entry > max) {
>>  				pr_err("Invalid skip entry\n");
>> -				goto err3;
>> +				goto err4;
> 
> This would be a good opportunity to reduce the possibility of future
> errors.  Please consider renaming err{1,2,3,4} to something more
> recognizable while you are here.
> 
  Ok, this is done as a part of patch#13.

Regards,
 Sricharan 
