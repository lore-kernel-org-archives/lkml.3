Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab3GBK1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:27:52 -0400
Received: from multi.imgtec.com ([194.200.65.239]:47782 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab3GBK1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:27:51 -0400
Message-ID: <51D2A46A.2000808@imgtec.com>
Date: Tue, 2 Jul 2013 10:59:06 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] metag: cpu hotplug: route_irq: preserve irq mask
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-6-git-send-email-james.hogan@imgtec.com> <51D27044.6050604@linux.vnet.ibm.com>
In-Reply-To: <51D27044.6050604@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_02_11_26_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/13 07:16, Srivatsa S. Bhat wrote:
> On 07/01/2013 09:34 PM, James Hogan wrote:
>> The route_irq() function needs to preserve the irq mask by using the
>> _irqsave/irqrestore variants of raw spin lock functions instead of the
>> _irq variants. This is because it is called from __cpu_disable() (via
>> migrate_irqs()), which is called with IRQs disabled, so using the _irq
>> variants re-enables IRQs.
>>
>> This appears to have been causing occasional hits of the
>> BUG_ON(!irqs_disabled()) in __irq_work_run() during CPU hotplug soak
>> testing:
>>   BUG: failure at kernel/irq_work.c:122/__irq_work_run()!
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> ---
> 
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks for taking the time to review these patches

Cheers
James

