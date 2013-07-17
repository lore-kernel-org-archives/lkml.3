Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab3GQXG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:06:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51321 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965040Ab3GQXGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:06:23 -0400
Message-ID: <51E7236D.3010700@codeaurora.org>
Date: Wed, 17 Jul 2013 16:06:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Javi Merino <javi.merino@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if
 UP system
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org> <20130712111322.GC3213@e102654-lin.cambridge.arm.com> <20130712121023.GB27430@codeaurora.org> <51E71249.4050200@codeaurora.org> <alpine.LFD.2.03.1307171830170.14924@syhkavp.arg> <51E71C78.6080604@codeaurora.org> <alpine.LFD.2.03.1307171849180.14924@syhkavp.arg>
In-Reply-To: <alpine.LFD.2.03.1307171849180.14924@syhkavp.arg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/13 15:53, Nicolas Pitre wrote:
> On Wed, 17 Jul 2013, Stephen Boyd wrote:
>
>> On 07/17/13 15:34, Nicolas Pitre wrote:
>>> On Wed, 17 Jul 2013, Stephen Boyd wrote:
>>>
>>>> On 07/12/13 05:10, Stephen Boyd wrote:
>>>>> On 07/12, Javi Merino wrote:
>>>>>> I agree, we should drop the check.  It's annoying in uniprocessors and
>>>>>> unlikely to be found in the real world unless your gic entry in the dt
>>>>>> is wrong.
>>> And that's a likely outcome in the real world.
>>>
>>>>> Ok. How about this?
>>>> Any comments?
>>> What about this instead:
>> Unfortunately arm64 doesn't have SMP_ON_UP. 
> And why does that matter?

Because the gic driver is compiled on both arm and arm64? I suppose we
could define is_smp() to 1 on arm64 but its probably better to rely on
generic kernel things instead of arch specific functions.

>
>> It sounds like you preferred the first patch using num_possible_cpus()
> Probably, yes.  I didn't follow the early conversation though.

This was the first patch:

---8<----

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 19ceaa6..589c760 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -368,7 +368,7 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
 			break;
 	}
 
-	if (!mask)
+	if (!mask && num_possible_cpus() > 1)
 		pr_crit("GIC CPU mask not found - kernel will fail to boot.\n");
 
 	return mask;


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

