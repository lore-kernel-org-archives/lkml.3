Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaLOPKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:10:05 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54153 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaLOPKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:10:01 -0500
Message-ID: <548EF9C1.2070505@gmail.com>
Date: Mon, 15 Dec 2014 08:09:53 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 00/22] perf tools: Introduce an abstraction for Instruction
 Tracing
References: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com> <548B1425.7090500@gmail.com> <20141212185324.GF9845@kernel.org> <548EA52B.5060401@intel.com>
In-Reply-To: <548EA52B.5060401@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/14 2:08 AM, Adrian Hunter wrote:
> On 12/12/14 20:53, Arnaldo Carvalho de Melo wrote:
>> Em Fri, Dec 12, 2014 at 09:13:25AM -0700, David Ahern escreveu:
>>> On 12/12/14 6:47 AM, Adrian Hunter wrote:
>>>> Here is V3 of some more preparatory patches for Intel PT
>>>> that introduce an abstraction for Instruction tracing.
>>
>>> This is an x86-Intel only feature correct? If that is the case then the code
>>> should be not compiled for other architectures.
>
> It is not that simple. In the case of recording, it is not needed for
> architectures that don't support it, but in the case of session processing
> any architecture can (or should be able to) process the perf.data file of
> any other architecture.

Understood. perf is a kitchen sink tool and the size of binaries for 
embedded deployments is getting out of hand. e.g., for our PPC based 
systems the entire root filesystem is 46M with perf taking up almost 3M 
of that (stripped size too). New features need config options so user's 
can decide the feature scope of what they are building. And we need to 
get the kconfig style builds committed as well.

David
