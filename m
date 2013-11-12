Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3KLHOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:14:17 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43416 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3KLHOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:14:07 -0500
X-AuditID: 9c93016f-b7c75ae00000244e-b0-5281d53d758a
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Prevent condition that all sort keys are elided
References: <1383900822-14609-1-git-send-email-namhyung@kernel.org>
	<20131111112013.GC15810@gmail.com>
Date: Tue, 12 Nov 2013 16:14:04 +0900
In-Reply-To: <20131111112013.GC15810@gmail.com> (Ingo Molnar's message of
	"Mon, 11 Nov 2013 12:20:13 +0100")
Message-ID: <871u2mw0qr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, 11 Nov 2013 12:20:13 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>> +	/*
>> +	 * It makes no sense to elide all of sort entries.
>> +	 * Just revert them to show up again.
>> +	 */
>> +	list_for_each_entry(se, &hist_entry__sort_list, list)
>> +		if (!se->elide)
>> +			return;
>
> (Nit: please use curly braces around multi-line statements.)

Ah, okay.

>
>> +
>> +	list_for_each_entry(se, &hist_entry__sort_list, list)
>> +		se->elide = false;
>
> Looks good otherwise - this is the first step in the sort/key behavior 
> improvements that we talked about a few days ago, right?

Right.  And I'd like to wait bit more to hear other's opinion on this.

>
> Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,
Namhyung
