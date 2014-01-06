Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaAFIJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:09:13 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42311 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaAFIJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:09:11 -0500
X-AuditID: 9c930197-b7c4aae000003d84-5a-52ca64a5f412
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 03/21] perf hists: Add support for accumulated stat of hist entry
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-4-git-send-email-namhyung@kernel.org>
	<20140105162650.GC10018@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:09:09 +0900
In-Reply-To: <20140105162650.GC10018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 17:26:50 +0100")
Message-ID: <87k3ededlm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 17:26:50 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:09PM +0900, Namhyung Kim wrote:
>> @@ -295,6 +306,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
>>  			 */
>>  			he->branch_info = malloc(sizeof(*he->branch_info));
>>  			if (he->branch_info == NULL) {
>> +				free(he->stat_acc);
>
> probably not big deal but above free should be under
> symbol_conf.cumulate_callchain check..

The he->stat_acc will be NULL if !symbol_conf.cumulate_callchain so it's
safe to call free().

And I'll add the call to free() into hist_entry__free() anyway.

Thanks,
Namhyung
