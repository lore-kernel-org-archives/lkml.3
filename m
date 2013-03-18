Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3CROlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:41:02 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:63763 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3CROk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:40:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130317230812.GE4977@n2100.arm.linux.org.uk>
References: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com>
	<20130315181449.GX4977@n2100.arm.linux.org.uk>
	<CAM16m2n_Of0MJNtUsrL0MS2cXBZUHg9RzjSHcboDiHKB3s0cdw@mail.gmail.com>
	<20130317200543.GA20174@mudshark.cambridge.arm.com>
	<20130317230812.GE4977@n2100.arm.linux.org.uk>
Date: Mon, 18 Mar 2013 22:40:56 +0800
Message-ID: <CAM16m2kHp46rgiivUt7EL1Dr06b4UobzT3aXgPZOpFJP-FkTSA@mail.gmail.com>
Subject: Re: udelay function delays the wrong time interval in multiprocessor
 system, if ARCH_HAS_READ_CURRENT_TIMER is not defined and on current timer is used.
From: chpoph <chpoph@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Sun, Mar 17, 2013 at 08:05:43PM +0000, Will Deacon wrote:
>Do you actually have an ARM platform that can scale the CPU frequencies
independently?

Yes,  my smart phone use Qualcomm's 8x25 and 8064 platform, which can
scale the CPU frequencies independently. I test the delay loop, the
phone can't get accurate delayed time intervals. I think there are
four reasons: the task scheduling, IRQ handling, memory accessing, and
udelay may be called between CPU frequency changing and
loops_per_jiffy changing. The system's performance decreased greatly
after adding preempt_{enable, disable}.

I used the current timer to delay a time period at last, the timer's
frequency is constant.
