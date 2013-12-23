Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab3LWOog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:44:36 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45055 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3LWOof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:44:35 -0500
Message-ID: <52B84C49.70001@gmail.com>
Date: Mon, 23 Dec 2013 09:44:25 -0500
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
References: <528484CB.7@tu-dresden.de> <20131114083930.GC16543@gmail.com> <528490DE.4080204@tu-dresden.de> <20131114100552.GA5064@gmail.com> <528E1EE6.9040407@tu-dresden.de> <20131127135137.GA24403@gmail.com> <52B437AA.4090102@tu-dresden.de> <52B479E1.7020204@gmail.com> <20131223131051.GB585@localhost.localdomain>
In-Reply-To: <20131223131051.GB585@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/13, 8:10 AM, Frederic Weisbecker wrote:
> On Fri, Dec 20, 2013 at 10:09:53AM -0700, David Ahern wrote:
>> On 12/20/13, 5:27 AM, Joseph Schuchart wrote:
>>> I know this comes late, but: As far as I can see, your change does not
>>> preserve the logic of the code I suggested. The idea was to first gather
>>> all the maximum timestamps of all cpus (that is, the last timestamp seen
>>> on each cpu) and then determine the minimum of these maxima. These are
>>> two distinct steps that I think cannot be combined in one update. Your
>>
>>   A number of people have reported similar problems -- timestamps
>> below last flush time. This approach would solve that problem for
>> data processed from files, so it would be a good improvement.
>
> Could it be near what you're looking for?
>
> https://lkml.org/lkml/2012/2/18/53
>

Forgot about that patch. It is similar to what Joseph wants for 
analyzing a file.

I was carrying that patch while working on perf-kvm-stat-live last Fall. 
It does not solve the problem for live commands, so ended up dropping it 
and going with local (to the command) hacks. I still think for live 
commands getting a perf_clock timestamp at the start of a round and 
using that as the flush time will work best.

David
