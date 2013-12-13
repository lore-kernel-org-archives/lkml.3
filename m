Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3LMOgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:36:05 -0500
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:44136 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020Ab3LMOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:36:03 -0500
Message-ID: <52AB1B14.6030905@st.com>
Date: Fri, 13 Dec 2013 14:35:00 +0000
From: Angus Clark <angus.clark@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100312 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
        <linus.walleij@linaro.org>, <linux-mtd@lists.infradead.org>,
        Angus CLARK <angus.clark@st.com>
Subject: Re: [PATCH v3 04/36] mtd: st_spi_fsm: Supply framework for device
 requests
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org> <1385727565-25794-5-git-send-email-lee.jones@linaro.org> <20131210201943.GC27149@ld-irv-0074.broadcom.com>
In-Reply-To: <20131210201943.GC27149@ld-irv-0074.broadcom.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.49.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 08:19 PM, Brian Norris wrote:
> On Fri, Nov 29, 2013 at 12:18:53PM +0000, Lee Jones wrote:
>> --- a/drivers/mtd/devices/st_spi_fsm.c
>> +static void stfsm_wait_seq(struct stfsm *fsm)
>> +{
>> +	unsigned long timeo = jiffies + HZ;
>> +
>> +	while (time_before(jiffies, timeo)) {
>> +		if (stfsm_is_idle(fsm))
>> +			return;
>> +
>> +		cond_resched();
>> +	}
>> +
>> +	dev_err(fsm->dev, "timeout on sequence completion\n");
> 
> I believe the timeout logic is incorrect. What if we wait a "long time"
> to call stfsm_wait_seq() (due to scheduling, or otherwise)? Then the
> while loop might not even run once (time_before(x, y) is false). Or what
> if cond_resched() waits for a long time...
> 
> So you need an extra check of stfsm_is_idle() after the while loop,
> before you declare a timeout.

Yes, good catch, this needs to updated.

Cheers,

Angus
