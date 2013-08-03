Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3HCTiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:38:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:41285 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab3HCTiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:38:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,808,1367996400"; 
   d="scan'208";a="381406129"
Message-ID: <51FD5C0C.8080706@intel.com>
Date: Sat, 03 Aug 2013 22:37:48 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com> <1375218838-31042-2-git-send-email-adrian.hunter@intel.com> <20130731145820.GF3614@ghostprotocols.net> <20130731172833.GH3614@ghostprotocols.net> <20130731174624.GJ3614@ghostprotocols.net>
In-Reply-To: <20130731174624.GJ3614@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/2013 8:46 p.m., Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 31, 2013 at 02:28:33PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Still investigating, but the attached patch is needed to handle such
>> failure cases:
>
>> [root@zoo ~]# perf test 21
>> 21: Test object code reading                               : FAILED!
>> [root@zoo ~]# perf test -v 21
>
> Lowering the freq to 4kHz gets me to where I think you was at this
> point:
>
> [root@zoo ~]# perf test -v 21
> 21: Test object code reading                               :
> --- start ---
> Looking at the vmlinux_path (6 entries long)
> symsrc__init: cannot get elf header.
> Using /lib/modules/3.11.0-rc2+/build/vmlinux for symbols
> Parsing event 'cycles'
> Reading object code for memory address: 0xffffffff8101ce7d
> File is: /lib/modules/3.11.0-rc2+/build/vmlinux
> On file address is: 0xffffffff8101ce7d
> dso__data_read_offset failed
> ---- end ----
> Test object code reading: FAILED!
> [root@zoo ~]#
>
> I.e. we need the follow on patches to fix this issue, right?

Yes.  It is using an "identity" map so the memory address and on-file 
address are the same - which doesn't work of course.

>
> I'll merge my changes with your first patch and continue from there.

Please take V3.
