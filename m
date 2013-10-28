Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3J1K5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:57:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58059 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3J1K5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:57:49 -0400
Message-ID: <526E4328.1010702@hitachi.com>
Date: Mon, 28 Oct 2013 19:57:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <20131026095023.GF14237@gmail.com>
In-Reply-To: <20131026095023.GF14237@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/26 18:50), Ingo Molnar wrote:
> 
> * Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
> 
>> Hi Pekka,
>>
>>>>
>>>> You can now use it in all perf tools, such as:
>>>>
>>>>     perf record -e libc:my_event -aR sleep 1
>>>
>>> Is there a technical reason why 'perf list' could not show all the
>>> available SDT markers on a system and that the 'market to event'
>>> mapping cannot happen automatically?
>>>
>>
>> Technically feasible. But then we would have to parse each of the 
>> libraries and executables to list them. Right? I am not sure if 
>> such a delay is acceptable.
> 
> I'd say lets try Pekka's suggestion and make it more palatable if 
> there's complaints about the delay. (SSD systems are becoming 
> dominant and there the search should be reasonably fast.)
> 
> We could also make 'perf list' more sophisticated, if invoked 
> naively as 'perf list' then maybe it should first display the 
> various event categories, with a (rough) count:
> 
> $ perf list
>    34 hardware events       # use 'perf list --hw'    to list them
>    40 hw-cache events       # use 'perf list --cache' to list them
>    20 software events       # use 'perf list --sw'    to list them
>     2 raw events            # use 'perf list --raw'   to list them
>   120 tracepoints           # use 'perf list --tp'    to list them
>   >10 SDT tracepoints       # use 'perf list --sdt'   to list them
> 
>  # use 'perf list -a' to list all events
>  # use 'perf list ./binary' to list events in a given binary
> 
> I.e. bring a bit more structure into it.

Ah, that's nice to me too ;)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


