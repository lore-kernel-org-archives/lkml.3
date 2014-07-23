Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbaGWXfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:35:32 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49559 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbaGWXfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:35:31 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 52/52] perf tools: Add support for 32-bit compatibility VDSOs
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
	<1406035081-14301-53-git-send-email-adrian.hunter@intel.com>
	<20140723130215.GC1207@krava.brq.redhat.com>
	<53CFBFCB.90303@intel.com>
Date: Thu, 24 Jul 2014 08:35:28 +0900
In-Reply-To: <53CFBFCB.90303@intel.com> (Adrian Hunter's message of "Wed, 23
	Jul 2014 16:59:39 +0300")
Message-ID: <87mwbzk5rz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Wed, 23 Jul 2014 16:59:39 +0300, Adrian Hunter wrote:
> On 07/23/2014 04:02 PM, Jiri Olsa wrote:
>> On Tue, Jul 22, 2014 at 04:18:01PM +0300, Adrian Hunter wrote:
>>> 'perf record' post-processes the event stream  to create
>>> a list of build-ids for object files for which sample
>>> events have been recorded.  That results in those object
>>> files being recorded in the build-id cache.
>> 
>> SNIP
>> 
>>>  
>>>  	if (vdso_info->vdso.found)
>>>  		unlink(vdso_info->vdso.temp_file_name);
>>> +#if BITS_PER_LONG == 64
>>> +	if (vdso_info->vdso32.found)
>>> +		unlink(vdso_info->vdso.temp_file_name);
>>> +	if (vdso_info->vdsox32.found)
>>> +		unlink(vdso_info->vdso.temp_file_name);
>>> +#endif

Looks like copy-and-paste errors.  Did you mean below?

#if BITS_PER_LONG == 64
	if (vdso_info->vdso32.found)
		unlink(vdso_info->vdso32.temp_file_name);
	if (vdso_info->vdsox32.found)
		unlink(vdso_info->vdsox32.temp_file_name);
#endif

                                      ^^^


Thanks,
Namhyung
