Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3KAGGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:06:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64297 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3KAGGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:06:11 -0400
X-AuditID: 9c93016f-b7b28ae00000111e-c9-527344d1bb5b
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf timechart: always try to print at least 15 tasks
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
	<1382439412-23713-2-git-send-email-stfomichev@yandex-team.ru>
	<87y55c5xdt.fsf@sejong.aot.lge.com>
	<20131029092433.GA3406@stfomichev-desktop>
Date: Fri, 01 Nov 2013 15:06:09 +0900
In-Reply-To: <20131029092433.GA3406@stfomichev-desktop> (Stanislav Fomichev's
	message of "Tue, 29 Oct 2013 13:24:33 +0400")
Message-ID: <878ux864ha.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Tue, 29 Oct 2013 13:24:33 +0400, Stanislav Fomichev wrote:
>> 1. introduce while loop: it's a behavioral change so that it can be a
>> separate patch.  But it seems not checking the process filter - in that
>> case the loop is almost useless IMHO.
> Could you please elaborate on 'not checking the process filter'?

I meant it doesn't check whether process filter is set.  If the filter
is set calling determine_display_tasks() multiple times is meaningless
since it doesn't check the threashold at all.

>
> This loop is for the case when process filter is not set, but when the
> filter is set it should also work (because determine_display_tasks calls
> determine_display_tasks_filtered in case of process filter).
> We just check the return value and loop while number of tasks is not
> within the desired range (or thresh is zero).
>
>> 2. new -n option: it should update Documentation/perf-timechart.txt
>> also.  And the long option name "number" is too general.
> Does renaming "number" to "proc-num" sounds ok?

Much better.

>
>> 3. two if(proc_num): what is this?  Is it for patch 2?
> That's for the '-n 0' case, to completely skip tasks information.
>
> Thanks for your comments, I'll split this patch into two parts and
> update the docs.

Thanks,
Namhyung
