Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423631Ab3FURpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:45:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52853 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423545Ab3FURph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:45:37 -0400
Message-ID: <51C4913F.2020608@codeaurora.org>
Date: Fri, 21 Jun 2013 10:45:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1371820267-12099-1-git-send-email-srinivas.kandagatla@st.com> <alpine.DEB.2.02.1306211634510.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306211634510.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/13 08:56, Thomas Gleixner wrote:
>
>> +static irqreturn_t gt_clockevent_interrupt(int irq, void *dev_id)
>> +{
>> +	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
> What kind of construct is this?
>
> You are using request_percpu_irq() and the device id is pointing to
> per cpu memory. Why do you need this horrible pointer indirection?
>
> Because a lot of other ARM code uses the same broken construct?

This is an artifact of the ARM local timer API. I have been trying for a
few months to remove the API but I need my first two patches to go
through the tip/timers tree. Please accept them so we don't have this
construct anymore.

https://lkml.org/lkml/2013/6/3/584

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

