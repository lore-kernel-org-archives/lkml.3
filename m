Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3JAA3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 20:29:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51751 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3JAA3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 20:29:03 -0400
MIME-Version: 1.0
In-Reply-To: <52498187.10900@gmail.com>
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org> <52498187.10900@gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Mon, 30 Sep 2013 17:28:41 -0700
X-Google-Sender-Auth: J_8X26qA8AoLsEOBHus0iWoeN7M
Message-ID: <CAPz6YkWOQ4_YPHjHYM5-rUc7wj1Ygikdk2EFTCPGyaKmb+DuqQ@mail.gmail.com>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data file
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 6:49 AM, David Ahern <dsahern@gmail.com> wrote:
> On 9/30/13 2:19 AM, Namhyung Kim wrote:
>>
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>
>> perf-record updates the header in the perf.data file at termination.
>> Without this update perf-report (and other processing built-ins) it
>> caused an infinite loop when perf report (or something like) called.
>>
>> This is because the algorithm in __perf_session__process_events()
>> depends on the data_size which is read from file header.  Use file
>> size directly instead in this case to do the best-effort processing.
>>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Sonny Rao <sonnyrao@chromium.org>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
>
> worked ok for me. Sonny can you verify?

Yes, it works for me as well, thanks!


> David
>
