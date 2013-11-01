Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3KAGKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:10:33 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64396 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3KAGKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:10:32 -0400
X-AuditID: 9c93017e-b7ca6ae000000e8a-63-527345d68052
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] perf timechart: add support for displaying only tasks related data
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-4-git-send-email-stfomichev@yandex-team.ru>
	<87ppqo5wgx.fsf@sejong.aot.lge.com>
	<20131029093329.GC3406@stfomichev-desktop>
Date: Fri, 01 Nov 2013 15:10:30 +0900
In-Reply-To: <20131029093329.GC3406@stfomichev-desktop> (Stanislav Fomichev's
	message of "Tue, 29 Oct 2013 13:33:29 +0400")
Message-ID: <87zjpo4ppl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013 13:33:29 +0400, Stanislav Fomichev wrote:
>> Hmm.. double negation is always confusing to me. :-/  How about making
>> it a boolean option that sets "task_only" variable?
> Ok.
>
>> Also need to update the doc.  And what if user gives -P and -T options
>> at the same time?
> Is something like this is enough (or you'd like some printout with error
> details)?
>
> if (!proc_num && task_only)
> 		usage_with_options(timechart_usage, options);

It'd be better if we have:

	if (power_only && task_only) {
		pr_err("-P and -T options cannot be used at the same time.\n");
		return -1;
	}

Thanks,
Namhyung
