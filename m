Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3CSA5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:57:47 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:60244 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3CSA5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:57:46 -0400
Date: Mon, 18 Mar 2013 20:57:35 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@Parags-iMac
To: Shuah Khan <shuahkhan@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, parag.lkml@gmail.com,
        eranian@google.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/48] 3.4.37-stable review
In-Reply-To: <CAKocOOPeyVnL_x_fK6b52-S+bHFsw_D_83oQtEVoMOyPh0QD_g@mail.gmail.com>
Message-ID: <alpine.LFD.2.03.1303182053410.6237@gmail.com>
References: <20130318210810.247845918@linuxfoundation.org> <CAKocOOPeyVnL_x_fK6b52-S+bHFsw_D_83oQtEVoMOyPh0QD_g@mail.gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Mar 2013, Shuah Khan wrote:

> I am seeing the following warning after suspend and resume:
> 
> [  665.841331] Component: resume devices, time: 10628

[snip]

> [  665.841446] Pid: 2686, comm: bash Not tainted 3.4.37-rc1+ #13
> [  665.841450] Call Trace:
> [  665.841463]  [<ffffffff8105136f>] warn_slowpath_common+0x7f/0xc0
> [  665.841471]  [<ffffffff81051466>] warn_slowpath_fmt+0x46/0x50
> [  665.841478]  [<ffffffff81097086>] suspend_test_finish+0x86/0x90
> [  665.841484]  [<ffffffff81096c2e>] suspend_devices_and_enter+0x16e/0x330
> [  665.841491]  [<ffffffff81096f7f>] pm_suspend+0x18f/0x1f0

It is coming from kernel/power/suspend_test.c:53 -
 
/* Warning on suspend means the RTC alarm period needs to be
         * larger -- the system was sooo slooowwww to suspend that the
         * alarm (should have) fired before the system went to sleep!
         *
         * Warning on either suspend or resume also means the system
         * has some performance issues.  The stack dump of a WARN_ON
         * is more likely to get the right attention than a printk...
         */
        WARN(msec > (TEST_SUSPEND_SECONDS * 1000),
             "Component: %s, time: %u\n", label, msec);

That just means your system is slow to suspend/resume. I've seen the same 
many times on my older machines - you can likely ignore it.

--Parag
