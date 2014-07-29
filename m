Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaG2XiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:38:17 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:49834 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaG2XiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:38:16 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [RFC/PATCH] perf tools: Check recorded kernel version when finding vmlinux
References: <1406621715-27819-1-git-send-email-namhyung@kernel.org>
	<53D7BA6E.9040002@gmail.com>
Date: Wed, 30 Jul 2014 08:38:14 +0900
In-Reply-To: <53D7BA6E.9040002@gmail.com> (David Ahern's message of "Tue, 29
	Jul 2014 09:14:54 -0600")
Message-ID: <87tx5zhh21.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 29 Jul 2014 09:14:54 -0600, David Ahern wrote:
> On 7/29/14, 2:15 AM, Namhyung Kim wrote:
>> This requires to change signature of symbol__init() to receive struct
>> perf_session_env *.  This patch only does some trivial changes - some
>
> Why only pass the env for perf-report? Why not for any command
> analyzing a file? So for live commands env is NULL meaning use host
> paths; for recorded files pass env from session header and use it
> (plus symbol settings like symfs).

Yes, it needs other changes like you said.  But I'd like to hear from
your opinions on the problem and proposed fix before going further.

My other concern is that why it isn't covered by a build-id cache.

Thanks,
Namhyung
