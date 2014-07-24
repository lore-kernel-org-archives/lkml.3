Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbaGXX60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:58:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37010 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934753AbaGXX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:58:24 -0400
MIME-Version: 1.0
In-Reply-To: <39107.1406245502@turing-police.cc.vt.edu>
References: <1406095319-3627-1-git-send-email-ast@plumgrid.com>
	<1406095319-3627-2-git-send-email-ast@plumgrid.com>
	<39107.1406245502@turing-police.cc.vt.edu>
Date: Thu, 24 Jul 2014 16:58:23 -0700
Message-ID: <CAMEtUuyw0PJXF_EWfs+PVzGago_waFXCbndT4B2HGJ0HYiXh2A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: filter: split filter.c into two files
From: Alexei Starovoitov <ast@plumgrid.com>
To: Valdis.Kletnieks@vt.edu
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 4:45 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Tue, 22 Jul 2014 23:01:58 -0700, Alexei Starovoitov said:
>> BPF is used in several kernel components. This split creates logical boundary
>> between generic eBPF core and the rest
>>
>> kernel/bpf/core.c: eBPF interpreter
>>
>> net/core/filter.c: classic->eBPF converter, classic verifiers, socket filters
>>
>> This patch only moves functions.
>>
>> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
>> ---
>>  kernel/Makefile     |    1 +
>>  kernel/bpf/Makefile |    1 +
>>  kernel/bpf/core.c   |  536 +++++++++++++++++++++++++++++++++++++++++++++++++
> ++
>>  net/core/filter.c   |  511 ------------------------------------------------
>>  4 files changed, 538 insertions(+), 511 deletions(-)
>>  create mode 100644 kernel/bpf/Makefile
>>  create mode 100644 kernel/bpf/core.c
>>
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index f2a8b6246ce9..e7360b7c2c0e 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -87,6 +87,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
>>  obj-$(CONFIG_TRACEPOINTS) += trace/
>>  obj-$(CONFIG_IRQ_WORK) += irq_work.o
>>  obj-$(CONFIG_CPU_PM) += cpu_pm.o
>> +obj-$(CONFIG_NET) += bpf/
>
> I was expecting to see CONFIG_NETFILTER here.  Is CONFIG_NET intentional?

yes. it is config_net for now, until eBPF is completely separate from net.
Then it will gain its own config_bpf, so it can be used in net-less setups
or disabled in net-full setups by folks who care about last byte of .text size.
Future will tell.
