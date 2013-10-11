Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3JKPLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:11:19 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45420 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3JKPLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:11:17 -0400
Message-ID: <52581511.2010909@gmail.com>
Date: Fri, 11 Oct 2013 09:11:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org> <20131011055829.GA4975@gmail.com> <20131011073448.GA11064@krava.redhat.com>
In-Reply-To: <20131011073448.GA11064@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/13 1:34 AM, Jiri Olsa wrote:
> '-g' takes optional parameter, so having it in front of
> non option string is causing the error, you could use:
>
> ./perf record -g -- ~/hackbench 10
>
> maybe we could display just only help string of the option
> we failed to process in this case

That's a syntax change introduced I believe when you added dwarf 
support. Every now and then I slip up and type -ga -- something that 
worked up until the callchain arg was expanded -- and now it fails as -g 
wants to look at 'a' as an argument to it.

It would be nice to fix the callchain arg handler to not attempt to 
process the next argument if it is not fp or dwarf.

David

