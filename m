Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFEI7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:59:24 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59193 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaFEI7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:59:22 -0400
Message-ID: <53903169.3030404@arm.com>
Date: Thu, 05 Jun 2014 09:59:21 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 04/11] sched: Allow all archs to set the power_orig
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org> <53888FF0.4020403@arm.com> <CAKfTPtB+2dsHjZw=KkYgbP4EnPebLjfdNeVDAStXFJ2h8wbm+g@mail.gmail.com> <538EE9E9.7090605@arm.com> <CAKfTPtB9bh1_ZeQSFsC2eoBaytDBNcmn8ZZpY7Weqxui75Z2kA@mail.gmail.com>
In-Reply-To: <CAKfTPtB9bh1_ZeQSFsC2eoBaytDBNcmn8ZZpY7Weqxui75Z2kA@mail.gmail.com>
X-OriginalArrivalTime: 05 Jun 2014 08:59:15.0701 (UTC) FILETIME=[6D7A2A50:01CF809C]
X-MC-Unique: 114060509591908301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>> Firstly, we need to scale cpu power in update_cpu_power() regarding
>> uArch, frequency and rt/irq pressure.
>> Here the freq related value we get back from arch_scale_freq_power(...,
>> cpu) could be an instantaneous value (curr_freq(cpu)/max_freq(cpu)).
>>
>> Secondly, to be able to scale the runnable avg sum of a sched entity
>> (se->avg->runnable_avg_sum), we preferable have a coefficient
>> representing uArch diffs (cpu_power_orig(cpu)/cpu_power_orig(most
>> powerful cpu in the system) and another coefficient (avg freq over 'now
> 
> AFAICT, the coefficient representing uArch diffs is already taken into
> account into power_freq thanks to scale_cpu, isn't it ?

True, but I can't see how the current signature of
arch_scale_cpu_power() and arch_scale_freq_power() fit into this uArch
and freq invariant updating of se->avg->runnable_avg_sum business.

>> - sa->last_runnable_update'(cpu)/max_freq(cpu). This value would have to
>> be retrieved from the arch in __update_entity_runnable_avg().
>>
[...]

