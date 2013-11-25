Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3KYOOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:14:21 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3707 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3KYOOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:14:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Nov 2013 06:08:03 -0800
Message-ID: <52935AB6.2000302@nvidia.com>
Date: Mon, 25 Nov 2013 19:42:06 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: IRQF_RESUME_EARLY and errors in dpm_suspend_noirq
References: <201311201020.08158.heiko@sntech.de>  <528C86C2.1070206@nvidia.com> <1385374413.11161.28.camel@kazak.uk.xensource.com>
In-Reply-To: <1385374413.11161.28.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 November 2013 03:43 PM, Ian Campbell wrote:
> On Wed, 2013-11-20 at 15:24 +0530, Laxman Dewangan wrote:
>> On Wednesday 20 November 2013 02:50 PM, Heiko Stübner wrote:
>>> Hi,
>>>
>>> Commit 9bab0b7fbace (genirq: Add IRQF_RESUME_EARLY and resume such IRQs
>>> earlier) split the suspend/resume of the irqs into two parts.
>>>
>>> The early-irqs get resumed during syscore_resume, while the rest get
>>> resumed by the regular resume_device_irqs.
>>>
>>> I may be blind, but where get the early-irqs resumed in the error
>>> path of dpm_suspend_noirq?
>>>
>>> When a suspend_noirq callback returns an error, dpm_resume_noirq gets called,
>>> which only calls resume_device_irqs while the suspend_device_irqs call in
>>> dpm_suspend_noirq suspends all irqs. So it does not seem that the early-irqs
>>> get resumed at all in this case.
>>>
>> I also faced same issue in our suspend failure path and posted fix
>> sometime ago as
>> https://lkml.org/lkml/2013/8/13/373
>>
>> It is still under review.
> IME zero comments since August is not "under review", it is "has slipped
> through the cracks" ;-)
>
> I would suggest you resend it.
>

Thanks all of you for review/ack/validating it.
I resend it today. Hope at this time it will be on tree.

Howevere, I have not added stable on cc.



