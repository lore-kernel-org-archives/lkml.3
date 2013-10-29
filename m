Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3J2JYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:24:44 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:37418 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab3J2JYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:24:43 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 29 Oct 2013 13:24:33 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf timechart: always try to print at least 15 tasks
Message-ID: <20131029092433.GA3406@stfomichev-desktop>
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
 <1382439412-23713-2-git-send-email-stfomichev@yandex-team.ru>
 <87y55c5xdt.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y55c5xdt.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. introduce while loop: it's a behavioral change so that it can be a
> separate patch.  But it seems not checking the process filter - in that
> case the loop is almost useless IMHO.
Could you please elaborate on 'not checking the process filter'?

This loop is for the case when process filter is not set, but when the
filter is set it should also work (because determine_display_tasks calls
determine_display_tasks_filtered in case of process filter).
We just check the return value and loop while number of tasks is not
within the desired range (or thresh is zero).

> 2. new -n option: it should update Documentation/perf-timechart.txt
> also.  And the long option name "number" is too general.
Does renaming "number" to "proc-num" sounds ok?

> 3. two if(proc_num): what is this?  Is it for patch 2?
That's for the '-n 0' case, to completely skip tasks information.

Thanks for your comments, I'll split this patch into two parts and
update the docs.
