Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab3JNUnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:43:03 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50171 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab3JNUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <525C55A6.1030406@zytor.com>
References: <5258E560.5050506@cn.fujitsu.com>
	<525B19C3.9040907@gmail.com>
	<20131014133835.GG4722@htj.dyndns.org>
	<525BFCF3.5010908@gmail.com>
	<20131014142719.GI4722@htj.dyndns.org>
	<525C02DC.4050706@gmail.com>
	<20131014145131.GJ4722@htj.dyndns.org>
	<525C0866.2010808@gmail.com>
	<20131014151902.GL4722@htj.dyndns.org>
	<525C0EFE.2010409@gmail.com>
	<CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
	<525C55A6.1030406@zytor.com>
Date: Mon, 14 Oct 2013 13:42:57 -0700
X-Google-Sender-Auth: M6f09SJQTCsQEp0jlQ2fLsqUv2E
Message-ID: <CAE9FiQUQaB2RAPyNjW8vF1uEigCEaxVFH1PBs=xgYNRRCpZPuw@mail.gmail.com>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>, Tejun Heo <tj@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 1:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
...
>> 2. also we should avoid adding "movable_nodes" command line.
...
>> 6. in the long run, We should rework our NUMA booting:
>> a. boot system with boot numa nodes early only.
>> b. in later init stage or user space, init other nodes
>> RAM/CPU/PCI...in parallel.
>> that will reduce boot time for 8 sockets/32 sockets dramatically.
>>
>> We will need to parse srat table early so could avoid init memory for
>> non-boot nodes.
>>
>
> I really like the long-term plan (and, I might want to add, the above
> writeup.)
>
> However, I don't understand how we can avoid #2, given that it is
> fundamentally a sysadmin-driven tradeoff between performance and
> reliability.

If we make all numa systems support nodes hot-remove logically.
like we boot system with node0, and hot add other nodes one by one,
we should hot remove them later.

Thanks

Yinghai
