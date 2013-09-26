Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3IZRd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:33:59 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:39927 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3IZRd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <52443800.5080200@gmail.com>
References: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org> <52443800.5080200@gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Thu, 26 Sep 2013 10:33:35 -0700
X-Google-Sender-Auth: vbWXIYYh4qaMTVESczPMZRfOswg
Message-ID: <CAPz6YkUbeiZHtTVg56PG=v51jhhGibHada_t0G5cfx8P_JP6Ww@mail.gmail.com>
Subject: Re: [PATCH] perf: fix infinite loop with corrupted header
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 6:34 AM, David Ahern <dsahern@gmail.com> wrote:
> On 9/25/13 11:20 PM, Sonny Rao wrote:
>>
>> We recently ran into a corrupt perf data file which mostly looked okay
>> but the section size for data was set to 0.  This caused perf report to
>> get into an infinite loop in __perf_session_process_events().  Let's
>> just avoid this by bailing early and reporting it if there's an
>> invalid header.
>
>
> Been suggested before:
> https://lkml.org/lkml/2013/5/9/405
>
> Other changes went in around that time as well. Are you still seeing the
> loop on latest source?

I'm still seeing it on 3.12-rc1.  I haven't tested anything newer or
in the perf git tree.
Thanks

>
> David
