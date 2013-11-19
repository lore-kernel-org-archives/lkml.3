Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3KSIFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:05:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:58885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3KSIFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:05:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,727,1378882800"; 
   d="scan'208";a="435845779"
Message-ID: <528B1D7C.5010400@intel.com>
Date: Tue, 19 Nov 2013 10:12:44 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf tools: Allow '--inherit' as the negation of
 '--no-inherit'
References: <1384768557-23331-1-git-send-email-adrian.hunter@intel.com> <1384768557-23331-3-git-send-email-adrian.hunter@intel.com> <528A8379.5030908@gmail.com>
In-Reply-To: <528A8379.5030908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/13 23:15, David Ahern wrote:
> On 11/18/13, 2:55 AM, Adrian Hunter wrote:
>> Long options can be negated by prefixing them
>> with 'no-'.  However options that already start
>> with 'no-', such as '--no-inherit' result in ugly
>> double 'no's.  Avoid that by accepting that the
>> removal of 'no-' also negates the long option.
>>
> 
> Why not cleanup the options for the commands and move all of the no-xxxx to
> just xxxx? Anyone using no-xxxx would still just work by the existing code.

Interesting idea but the short and long options are a combination, and short
options don't work the same way e.g. -i and --no-inherit go together.

