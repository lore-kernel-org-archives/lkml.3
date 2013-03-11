Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3CKJ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:29:15 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:60781 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724Ab3CKJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:29:14 -0400
Message-ID: <513DA3BD.4070003@stericsson.com>
Date: Mon, 11 Mar 2013 10:28:29 +0100
From: Rickard Andersson <rickard.andersson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 0/4] time: dynamic irq affinity
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org> <513CC404.6000200@ti.com> <513CCF60.6060406@linaro.org> <513D4E79.5090307@ti.com> <513D9896.2010304@linaro.org> <513DA009.9080601@ti.com>
In-Reply-To: <513DA009.9080601@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 10:12 AM, Santosh Shilimkar wrote:
> On Monday 11 March 2013 02:10 PM, Daniel Lezcano wrote:
>> On 03/11/2013 04:24 AM, Santosh Shilimkar wrote:
>>> On Sunday 10 March 2013 11:52 PM, Daniel Lezcano wrote:
>> [ ... ]
>>
>>>> I don't think it is the case for all the ARM platforms, at least we
>>>> tested it on vexpress TC2 and u8500, and the number of IPI were reduced
>>>> very significantly increasing the idle time for cpu0. TC2 will need
>>>> another optimization on another area for the idle wake up to gain real
>>>> improvements.
>>>>
>>> You are missing my point. TC2 can be an exception since the SGI can wakeup
>>> CPUs even from low power states where local timer's are stalled. Is that
>>> the case with U8500 ?
>> Well, the cpuidle driver is not going into a deep idle state to check
>> this out.
>>
>> AFAICT this board has a specific firmware with the PRCMU (a device
>> managing the power on the board) and it replaces the GIC when going to
>> deep idle state, especially by reconnecting the GIC to the A9 cores
>> automatically when an interrupt occurs.
>>
> But most likely it will be limited to peripheral interrupts. SGI's
> are per-cpu irq's so you need to check that part.
>
In the U8500 case, when the first CPU is woken up it will work ok for 
that CPU to send an IPI to the other CPU.

BR
Rickard
