Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab3IDUjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:39:41 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35754 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab3IDUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:39:39 -0400
Message-ID: <52279A81.6010008@linux.vnet.ibm.com>
Date: Thu, 05 Sep 2013 02:09:29 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Wielaard <mjw@redhat.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com> <5225E2C5.3080001@linux.vnet.ibm.com>  <87a9jtt72j.fsf@sejong.aot.lge.com> <1378283148.4321.16.camel@bordewijk.wildebeest.org> <522777FF.2040906@linux.vnet.ibm.com> <1378320735.4321.62.camel@bordewijk.wildebeest.org>
In-Reply-To: <1378320735.4321.62.camel@bordewijk.wildebeest.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090420-1396-0000-0000-000003816057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 12:22 AM, Mark Wielaard wrote:
> On Wed, 2013-09-04 at 23:42 +0530, Hemant wrote:
>> On 09/04/2013 01:55 PM, Mark Wielaard wrote:
>>> Note that if you use the normal DTRACE_PROBE macros no semaphore will be
>>> inserted. And you can opt to not support probes that have a semaphore in
>>> perf if you think that is easier (just check the semaphore link-time
>>> address for the probe, it should normally be zero). Just warn: "No way I
>>> am going to probe something that might have a little extra overhead! I
>>> am no debugger..." :)
>> I agree. There will be an extra overhead but there may be some important
>> markers (on which we need to probe) may be worth this overhead?
> Yes, there maybe. And gdb and stap do support them. But it means not
> just setting the probe, but also incrementing (and decrementing) the
> semaphore. See "Semaphore Handling" under
> https://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
>
> Which is extra work, so for a minimal implementation that just supports
> normal (no-overhead) probes you might want to skip the extra work
> required to support them. I believe they are normally not used. I
> wouldn't recommend them and when I have added SDT probes myself I never
> used/needed them, but I haven't actually looked what others do.

Hmm, I agree as normally they aren't used. Also in normal usage, they 
aren't needed. Avoiding this seems the right choice for now. Will just 
filter out them as suggested by Masami.

Thanks
Hemant

>
> Cheers,
>
> Mark
>

