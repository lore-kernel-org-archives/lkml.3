Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaAVUsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:48:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58361 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaAVUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:47:59 -0500
Message-ID: <52E02E7E.4050203@codeaurora.org>
Date: Wed, 22 Jan 2014 12:47:58 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>
Subject: Re: [PATCH v2 5/7] ARM: perf_event: Fully support Krait CPU PMU events
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org> <1389808535-23852-6-git-send-email-sboyd@codeaurora.org> <20140121180711.GN30706@mudshark.cambridge.arm.com> <52DEBE6B.7000904@codeaurora.org>
In-Reply-To: <52DEBE6B.7000904@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/14 10:37, Stephen Boyd wrote:
> On 01/21/14 10:07, Will Deacon wrote:
>> Do you need isbs to ensure the pmresrn side-effects have happened, or are
>> the registers self-synchronising? Similarly for your other IMP DEF
>> registers.
> There aren't any isbs in the downstream android sources so I assume
> they're self synchronizing. I'll confirm with the CPU designers to make
> sure.
>

CPU folks say no need for isb. They mentioned that the lack of an isb
after the armv7_pmnc_enable_counter() call will leave the action of
enabling the counter "in-flight". The window is probably pretty short on
an SMP kernel because of the spin_unlock right after with the barriers
in it, but the same can't be said for a UP kernel.

Also, the fuzzer didn't find anything else, but I found a bug in the
bitmap logic, updated and reran the fuzzer this morning. Everything
looks good.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

