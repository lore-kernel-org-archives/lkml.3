Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3KKJ0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:26:06 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:38451 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753072Ab3KKJZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:25:54 -0500
MIME-Version: 1.0
In-Reply-To: <527D8A17.9020208@codeaurora.org>
References: <1383739658-10036-1-git-send-email-vkale@apm.com>
	<527D8A17.9020208@codeaurora.org>
Date: Mon, 11 Nov 2013 14:55:53 +0530
Message-ID: <CAPrCYkcEVqL3Bt-FQEmQe3oC7pTx3psjPEncH3BwYTyLPQr29A@mail.gmail.com>
Subject: Re: [PATCH 0/2] genirq: arm64: perf: support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>, tglx <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, jcm@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 9, 2013 at 6:34 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 11/06/13 04:07, Vinayak Kale wrote:
>> This patch series adds support to handle interrupt registration/deregistration
>> in arm64 pmu driver when pmu interrupt type is percpu.
>>
>> Patches in this patch series were previously sent out as separate patches [1].
>> This patch series incorporates comments/fixes suggested for original patches.
>>
>> [1]
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/205888.html
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204414.html
>>
>> Vinayak Kale (2):
>>   genirq: error reporting in request_percpu_irq() and
>>     request_threaded_irq()
>>   arm64: perf: add support for percpu pmu interrupt
>>
>>  arch/arm64/kernel/perf_event.c |  109 +++++++++++++++++++++++++++++-----------
>>  kernel/irq/manage.c            |   12 +++--
>>  2 files changed, 89 insertions(+), 32 deletions(-)
>>
>
> What ever happened to the approach here[1]? It doesn't look very nice to
> have to request the irq first as a per-cpu interrupt and then try as a
> non-percpu interrupt when genirq already knows if its per-cpu or not.
>
> [1] http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/02955.html
I don't see any discussions on mailing list on approach taken in above patch.

IMO, if fixing up minor error reporting in existing functions can do
the job then we should avoid adding a new function.
