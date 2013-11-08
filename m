Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab3KHSQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:16:10 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47134 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab3KHSQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:16:08 -0500
MIME-Version: 1.0
In-Reply-To: <CADmjqpP4dxWoU_3dLzC5+JffvwnZaLV=uxFTghpMRoSL_85TrA@mail.gmail.com>
References: <1383791330-8289-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=2xjR=nr5hyMg9bve5_uVbV79R2FTxks0bLmL7kNV9Mg@mail.gmail.com>
	<CADmjqpNWYVxrXuo106rBuZeZ2BrkGFkmbMJ8jxi39c8kLiQ+iw@mail.gmail.com>
	<CAKohpon6DhiWMuszuznK4ZNCBTpy0_r3gGvTXCDMcktXpN3HEw@mail.gmail.com>
	<CADmjqpP4dxWoU_3dLzC5+JffvwnZaLV=uxFTghpMRoSL_85TrA@mail.gmail.com>
Date: Fri, 8 Nov 2013 23:46:06 +0530
Message-ID: <CAKohpo=Rq-Sds5FzVdxcAEb78sqemq5JCc3S+pc11mu_b_ZpNA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: conservative: fix requested_freq reduction issue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <skarafotis@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 23:13, Stratos Karafotis <skarafotis@gmail.com> wrote:
> Please let me rephrase my previous post. In some circumstances (depending
> on freq_step and freq_table values) CPU frequency will never reach to
> policy->max.
>
> For example suppose that (for simplicity values in MHz):
> policy->max = 1000
> policy->cur = 800
> requested_freq = 800
> freq_target = 300
>
> In 'first' iteration, if we return early with this code (because
> requested_freq will be
> 1100):
> if (dbs_info->requested_freq >= policy->max)
>      return;

That's not correct. At this point requested_freq would have been
800 only, and would have increased after this instruction to 1100.
So, in the first transition we will go to max freq, but not from the
second.

Though this piece of code is more simplified by the new solution
I gave.

> CPU freq will never go over 800MHz.
>
> I think the current code works correctly.
> - The requested freq will go to 1100 in first iteration.
> - __cpufreq_driver_target will change CPU freq to 1000
> - dbs_cpufreq_notifier will adjust the requested_freq to 1000

> So, I think there is no need for an extra check because of
> dbs_cpufreq_notifier code.

Now with the new code in place we are correcting requested_freq
in cs_check_cpu(), then why do we need dbs_cpufreq_notifier()?

What do you think?
