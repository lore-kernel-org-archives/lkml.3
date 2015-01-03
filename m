Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbbACPBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 10:01:50 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:49091 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbbACPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 10:01:46 -0500
MIME-Version: 1.0
In-Reply-To: <20150103022504.GB24430@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-7-git-send-email-namhyung@kernel.org> <20150103022504.GB24430@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sun, 4 Jan 2015 00:01:26 +0900
X-Google-Sender-Auth: KRoMRi2miLa037gjSmwxl-HyHt4
Message-ID: <CAM9d7ciu4dVKv+mT3fHPE=BdBfLXdU+6zD9STVEkzxET2REUuQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] perf tools: Append callchains only when requested
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Sat, Jan 3, 2015 at 11:25 AM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Mon, Dec 22, 2014 at 01:44:14PM +0900, Namhyung Kim escreveu:
>> The perf report --children can be called with callchain disabled so no
>> need to append callchains.  Actually the root of callchain tree is not
>> initialized properly in this case.
>
> Hi Namhyung,
>
>         I should have caught this using 'perf test', but it slipped
> thru, please try running 'perf test cumulation', I noticed that it fails
> and that if I revert this changeset it works again, can you please
> check?

This change should not affect the test result, but I guess the test
somehow relied on the undefined behavior.  Actually I posted a patch
to fix this problem.  So please take a look at the link below:

https://lkml.org/lkml/2014/12/22/561

Thanks,
Namhyung
