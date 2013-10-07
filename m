Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3JGPgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:36:01 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34844 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3JGPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:36:00 -0400
Message-ID: <5252D4DB.30302@gmail.com>
Date: Mon, 07 Oct 2013 09:35:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH 00/50] tools/perf: Speed up the build system
References: <1381147003-2574-1-git-send-email-mingo@kernel.org> <5252BCB4.5030802@gmail.com> <20131007141100.GA21873@gmail.com>
In-Reply-To: <20131007141100.GA21873@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/13 8:11 AM, Ingo Molnar wrote:
> These changes are not yet committed into any stable Git tree - I've pushed
> them out into:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.perf
>
> (it might take a few minutes for kernel.org to sync up.)

Tested on Fedora 12, 14, 16 with varying degrees of feature support 
installed. The tests that failed are all static builds with the command 
line:

make O=/tmp/junk -C tools/perf LDFLAGS=-static NO_DWARF=1

Passing LDFLAGS to the feature tests should handle that.

I also noticed that the dwarf test is still run even with the NO_DWARF 
option passed in:

[daahern@nxos-vdc-dev1 perf]$ make O=/tmp/junk LDFLAGS=-static 
NO_DWARF=1 -j 4
     BUILD: Doing 'make -j16' parallel build

Auto-detecting system features:

...                     backtrace: [ on  ]
...                         dwarf: [ on  ]
...                fortify-source: [ on  ]

Note the dwarf test shows 'on'.

David
