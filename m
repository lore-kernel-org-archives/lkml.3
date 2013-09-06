Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3IFN71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:59:27 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60950 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3IFN70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:59:26 -0400
Message-ID: <5229DFBA.5090909@gmail.com>
Date: Fri, 06 Sep 2013 07:59:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf kvm: fix sample_type manipulation
References: <1378450134-28982-1-git-send-email-adrian.hunter@intel.com> <20130906125304.GA29064@ghostprotocols.net>
In-Reply-To: <20130906125304.GA29064@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/13 6:53 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 06, 2013 at 09:48:54AM +0300, Adrian Hunter escreveu:
>> Manipulating the sample_type of an evsel requires
>> the use of:
>> 	perf_evsel__set_sample_bit()
>> and	perf_evsel__reset_sample_bit()
>
> Fine, but...

hmmm... this is a relatively new API (7be5ebe8). The kvm-live command 
and my scheduling daemon pre-date its introduction.

>
>> Manipulating the sample type of an evlist requires
>> the id position to be recalculated.

And this is hot of the presses ... 75562573.

>
> ... can't we hide this detail? I.e. we could do it like we do with the
> alloc_{mmap,poll}() evlist methods in perf_evlist__mmap(), checking if it was
> already done, etc.
>
> This we reduce the contact surface for tools using evlists and evsels.
>
> I.e., this sequence:
>
>
> +	perf_evlist__set_id_pos(evlist);
> +
>   	err = perf_evlist__open(evlist);
>
> Could remain just:
>
> 	err = perf_evlist__open(evlist);

perf code has been around a while now and I know there are a number of 
local analysis commands built around it. API changes like this -- 
required ones at that -- need to be simple and some error checking built 
in where possible.

... and documentation for the API on what commands should be doing and 
in what order.

David
