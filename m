Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaK2BFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 20:05:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64643 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751324AbaK2BFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 20:05:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Wang Weidong <wangweidong1@huawei.com>
Cc: viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com
Subject: Re: [PATCH 0/2] fix some problems for cpufreq
Date: Sat, 29 Nov 2014 02:26:20 +0100
Message-ID: <2248504.pAVebap2qN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417142619-14548-1-git-send-email-wangweidong1@huawei.com>
References: <1417142619-14548-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 28, 2014 10:43:37 AM Wang Weidong wrote:
> Hi Rafael and Viresh
> 
> Sorry to trouble you again. As for:
> "acpi-cpufreq: get the cur_freq from acpi_processor_performance states"
> I do it again, and add the other patch.
> 
> patch #1: acpi-cpufreq: make the freq_table store the same freq value
> 
> I think it can work. The set of available states which come
> from acpi won't change. Just like the power would be remove,
> the acpi driver will do that:
> call
>  ->acpi_processor_ppc_has_changed
>  ->cpufreq_update_policy
>  ->acpi_ppc_notifier_block.notifier_call
>    ->acpi_processor_ppc_notifier
>    ->cpufreq_verify_within_limits
> The progress will change the policy's min_freq and max_freq
> while it won't change the set of states(freq_tables).

OK, so the above information needs to go into the changelog of patch [1/2].
Also, please clarify the problem description in that changelog, it is very
difficult to understand the way it is now.

> patch #2: cpufreq: show the real avail freqs with the freq_table
> 
> when the min_freq and max_freq change, we should sync the availble
> freqs.

Why?  Do any other cpufreq drivers do that?

Rafael

