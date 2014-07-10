Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaGJNUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:20:51 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40217 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaGJNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:20:50 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c0-53be932edad4
Message-id: <53BE91E9.9090408@samsung.com>
Date: Thu, 10 Jul 2014 17:15:21 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 05/21] x86: cpu: don't sanitize early
 stages of a secondary CPU boot
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-6-git-send-email-a.ryabinin@samsung.com>
 <87egxunx8j.fsf@tassilo.jf.intel.com>
In-reply-to: <87egxunx8j.fsf@tassilo.jf.intel.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t/xq7p6k/cFG8x7Ym3xe+9MVos569ew
	WRy59p3d4vq3N4wWEx62sVus7G5ms9j+7C2TxcrOB6wWmx5fY7X4s2sHk8XlXXPYLO6t+c9q
	cfsyr8WlAwuYLFr2XWCyaPv8j9Vi38rzQNaSjUwWi4/cZrZ492wys8XmTVOZLX5seMzqIObR
	0tzD5jF/50dGj52z7rJ7LNhU6rFpVSebx6ZPk9g9ut5eYfJ4d+4cu8eJGb9ZPJ5cmc7ksXlJ
	vcfHp7dYPN7vu8rmcWbBEXaPz5vkAvijuGxSUnMyy1KL9O0SuDL61qxhKdjIUvH2ZgtTA+NG
	5i5GTg4JAROJGSt6oGwxiQv31rOB2EICSxklfm7l62LkArKbmSR+/HzLCJLgFdCSuLVnEzuI
	zSKgKnG+6yULiM0moCfxb9Z2sGZRgQiJA33PWCHqBSV+TL4HVMPBISKgInH8FNhMZoHvrBLr
	2w+A1QsLZEtc/9vFBLFsJaPE2ylHwZo5BYwkZr/vZwKxmQXUJSbNW8QMYctLbF7zlnkCo8As
	JDtmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ2P66g3HpMatDjAIcjEo8
	vC927wkWYk0sK67MPcQowcGsJMKbVbcvWIg3JbGyKrUoP76oNCe1+BAjEwenVAOjoyF//vMp
	Ns/n1d9f1r3DLfjb3HuT9bPkYy4/2Gn6zkudaRrTk0Tbg7v75rgEzedecdZ7m92W/7vceLhm
	WYdZ7/wgVKMTs2+HAcfKOY7TNz1UKf3Rv/rF1yud0c+nfe1Qm263+YHJm9mTz3SFvjxx06au
	8UCy4RoRXqf1gi8c+I7bKJzfJShuq8RSnJFoqMVcVJwIAEk3TNbLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 23:33, Andi Kleen wrote:
> Andrey Ryabinin <a.ryabinin@samsung.com> writes:
> 
>> Instrumentation of this files may result in unbootable machine.
> 
> This doesn't make sense. Is the code not NMI safe? 
> If yes that would need to be fixed because
> 
> Please debug more.
> 

Sure.
It turns out that  KASAN_SANITIZE_perf_event.o := n is not needed here.
The problem only with common.c

> perf is a common source of bugs (see Vice Weaver's fuzzer results),
> so it would be good to have this functionality for it.
> 
> -Andi
> 

