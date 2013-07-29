Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3G2WTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:19:18 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65040 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3G2WTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:19:16 -0400
Message-ID: <51F6EA60.7020208@gmail.com>
Date: Mon, 29 Jul 2013 16:19:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V8 04/15] perf tools: change machine__findnew_thread()
 to set thread pid
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com> <1374144177-24762-5-git-send-email-adrian.hunter@intel.com> <51F29DAC.7000803@gmail.com> <51F4F5D4.8080405@intel.com>
In-Reply-To: <51F4F5D4.8080405@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/13 4:43 AM, Adrian Hunter wrote:

>>> - thread = machine__findnew_thread(machine, event->ip.pid);
>>> + thread = machine__findnew_thread(machine, event->ip.pid,
>>> event->ip.pid);
>>
>> event->ip.tid? at a minimum current functionality is retained with
>> machine__findnew_thread(machine, 0, event->ip.pid)
>
> perf tools records mmap information against the process's main thread
> for which pid == tid.  So the correct values are being passed here.

Yes. It's a case by case -- if you want syms use pid, otherwise use tid. 
It would be less confusing if the API was improved - always take pid and 
tid along with an arg that says 'want syms' or a separate function name. 
But I digress.

Looking at your patch does maintain the tid element so it should be 
fine. I ran a few tests with perf-script and the output is the same 
after the patch, so..

Acked-by: David Ahern <dsahern@gmail.com>
