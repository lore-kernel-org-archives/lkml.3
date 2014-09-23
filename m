Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaIWMyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:54:12 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34736 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbaIWMyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140923122843.GF2979@krava.brq.redhat.com>
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
 <1411453828-14832-2-git-send-email-namhyung@kernel.org> <20140923122843.GF2979@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 23 Sep 2014 21:53:43 +0900
X-Google-Sender-Auth: JOLaOB2zTM2VcGHiPerFthgPkxE
Message-ID: <CAM9d7cgwSrqLNghb3Vdt-=c9w1iFq0wc-njVP4UxkWD4hXCteg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf callchain: Use global caching provided by libunwind
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 9:28 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Sep 23, 2014 at 03:30:28PM +0900, Namhyung Kim wrote:
>> The libunwind provides two caching policy which are global and
>> per-thread.  As perf unwinds callchains in a single thread, it'd
>> sufficient to use global caching.
>>
>> This speeds up my perf report from 14s to 7s on a ~260MB data file.
>> Although the output contains a slight difference (~0.01% in terms of
>> number of lines printed) on callchains which were not resolved.
>
> hum, the speedup is nice, but what was the diff output.. any example?
> The new version does not print some lines or different ones?

I don't have the result now - will post the diff when I go to the
office tomorrow.  But IIRC new version only adds new lines..

Thanks,
Namhyung
