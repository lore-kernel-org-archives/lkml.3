Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3JXUgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 16:36:49 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52960 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3JXUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 16:36:48 -0400
MIME-Version: 1.0
X-Originating-IP: [67.83.170.180]
In-Reply-To: <20131024201349.GG4998@ghostprotocols.net>
References: <1382583069-26121-1-git-send-email-patrick@parcs.ath.cx>
	<20131024201349.GG4998@ghostprotocols.net>
Date: Thu, 24 Oct 2013 16:36:47 -0400
Message-ID: <CA+C-WL9eP2p0SVF8CZi+KABvBOgHiuFKe9Znx2ioJfYLxxH0OA@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix library detection when building without libelf
From: Patrick Palka <patrick@parcs.ath.cx>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 4:13 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Wed, Oct 23, 2013 at 10:51:09PM -0400, Patrick Palka escreveu:
>> When I attempt to build perf on a system with slang but without libelf,
>> 'make' would wrongly complain that the slang library could not be found.
>>
>> It turns out that this was happening because we are not filtering -lelf
>> from EXTLIBS early enough.  As a result, the library test for slang
>> (ditto for gtk, libaudit, etc) erroneously passes -lelf to try-cc, which
>> of course fails on a system without libelf.
>>
>> This patch makes the filtering of -lelf from EXTLIBS occur right after
>> testing for libelf support, so that the subsequent library tests will
>> not erroneously pass -lelf to try-cc when building without libelf
>> support.
>
> Can you please check with the perf/core branch in my tree or Ingo's?
>
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core
>
> or Ingo's:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
>
> The feature detection was reworked and perhaps it is fixed there.
>
> - Arnaldo

I can't reproduce the detection failure in your branch, and a quick inspection
shows that the new feature-detection code is not subject to the kind of bug
that my patch fixed. So consider my patch obsolete.

Thanks,
Patrick
