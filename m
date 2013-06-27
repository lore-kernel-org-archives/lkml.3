Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3F0HwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:52:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:57314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab3F0HwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:52:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="336252488"
Message-ID: <51CBF083.3060705@intel.com>
Date: Thu, 27 Jun 2013 10:57:55 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com> <20130625123247.GA23329@krava.brq.redhat.com>
In-Reply-To: <20130625123247.GA23329@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 15:32, Jiri Olsa wrote:
> On Mon, Jun 24, 2013 at 04:16:09PM +0300, Adrian Hunter wrote:
>> Sample types need not be identical to determine
>> the sample id from the event.  Only the position
>> of the sample id needs to be the same.
>>
>> Compatible sample types are ones in which the bits
>> defined by PERF_COMPAT_MASK are the same.
>> 'perf_evlist__config()' forces sample types to be
>> compatible on that basis.
> 
> hi,
> one of the patches is breaking test 4:
> 
> [jolsa@krava perf]$ sudo ./perf test
>  1: vmlinux symtab matches kallsyms                        : Ok
>  2: detect open syscall event                              : Ok
>  3: detect open syscall event on all cpus                  : Ok
>  4: read samples using the mmap interface                  :Can't parse sample, err = -14
>  FAILED!
> 
> haven't checked deeply, but my guess is this one ;-)

Thanks for testing.  Fixed in V2.

