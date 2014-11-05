Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaKECyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:54:32 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59573 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKECyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:54:31 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf record: Do not save pathname in ./debug/.build-id directory for vmlinux
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
	<1415063674-17206-7-git-send-email-namhyung@kernel.org>
	<20141104132904.GE18464@kernel.org>
Date: Wed, 05 Nov 2014 11:54:29 +0900
In-Reply-To: <20141104132904.GE18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Tue, 4 Nov 2014 10:29:04 -0300")
Message-ID: <87lhnqxspm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 4 Nov 2014 10:29:04 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 04, 2014 at 10:14:32AM +0900, Namhyung Kim escreveu:
>> When perf record finishes a session recording, it then pre-process
>> samples in order to write build-id info from actually used DSOs.
>> During this process it'll call map__load() for kernel map, and it ends
>> up calling dso__load_vmlinux_path() which replaces dso->long_name.
>
> Can't we achieve the same end result without introducing yet another
> symbol_conf entry?
>
> I think there are way too many there, we need to remove, not add :-\

Agreed.

I also wanted to do it without a new entry, but failed to find a good
way of it as it's a common code called both from record and report path
and lives in a deep inside of sample processing.

>
> I'll add this since it improve the end result, but if you don't beat me
> to it I'll try to remove this symbol_conf entry while keeping the end
> result you achieved with it.

It'd be really appreciated!

Thanks,
Namhyung
