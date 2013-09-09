Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3IIOLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:11:15 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55679 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3IIOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:11:14 -0400
Message-ID: <522DD6FF.50107@gmail.com>
Date: Mon, 09 Sep 2013 07:11:11 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com> <20130909111749.GP31370@twins.programming.kicks-ass.net> <20130909113640.GA16401@krava.redhat.com> <20130909115518.GA26785@twins.programming.kicks-ass.net> <20130909140339.GB16401@krava.redhat.com>
In-Reply-To: <20130909140339.GB16401@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/13 7:03 AM, Jiri Olsa wrote:
> my usage currently is to having this running during the day:
> (well whenever I remember to run it.. ;-) )
>
>    [jolsa@krava perf]$ sudo ./perf record -g -M 1m -a
>
> and checking report when the system or app get stuck
>
> with multiple files I can just easily (or automaticaly)
> remove old ones without restarting session

Aren't you losing potentially important events by doing that -- FORK, 
COMM, MMAP?

I have a flight recorder style command that address this problem 
(long-running/daemons) by processing task events and then stashing the 
sample events on a time-ordered list with chopping to maintain the time 
window.

David
