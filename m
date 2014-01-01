Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaAASiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 13:38:07 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49502 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaAASiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 13:38:04 -0500
Message-ID: <52C46083.9070605@gmail.com>
Date: Wed, 01 Jan 2014 11:37:55 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <528490DE.4080204@tu-dresden.de> <20131114100552.GA5064@gmail.com> <528E1EE6.9040407@tu-dresden.de> <20131127135137.GA24403@gmail.com> <52B437AA.4090102@tu-dresden.de> <52B479E1.7020204@gmail.com> <20131223131051.GB585@localhost.localdomain> <52B84C49.70001@gmail.com> <20131226151429.GA15303@localhost.localdomain> <52BC4A13.1090508@gmail.com> <20131226153033.GC15303@localhost.localdomain>
In-Reply-To: <20131226153033.GC15303@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13, 8:30 AM, Frederic Weisbecker wrote:
> On Thu, Dec 26, 2013 at 10:24:03AM -0500, David Ahern wrote:
>> On 12/26/13, 10:14 AM, Frederic Weisbecker wrote:
>>>> I was carrying that patch while working on perf-kvm-stat-live last
>>>> Fall. It does not solve the problem for live commands, so ended up
>>>> dropping it and going with local (to the command) hacks. I still
>>>> think for live commands getting a perf_clock timestamp at the start
>>>> of a round and using that as the flush time will work best.

For perf-kvm-stat-live using perf_clock value at the start of the round 
as the flush time works beautifully:

https://github.com/dsahern/linux/commit/ba8b7b63d5dbdc95aedbbafa670c2232e0cc07a2

Never once failed with "Warning: Timestamp below last timeslice flush" 
error.

David

>>>
>>> Ok, but how would you fetch this perf clock timestamp, with an explicit read?
>>
>> One option is exporting perf_clock to userspace.
>>
>> Preferably a built-in option, https://lkml.org/lkml/2013/12/10/781,
>> but I can go the module route if I have to:
>> https://github.com/dsahern/linux/blob/perf-full-monty/README.ahern
>
> I see, that's one of the very verbose threads I've seen lately ;)
>


