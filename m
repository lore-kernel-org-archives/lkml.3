Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaAMIpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:45:49 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64458 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaAMIpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:45:47 -0500
X-AuditID: 9c930197-b7c20ae000001031-ed-52d3a7b9cfdf
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 10/28] perf report: Cache cumulative callchains
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
	<1389170793-21926-11-git-send-email-namhyung@kernel.org>
	<20140111160254.GD1131@krava.brq.redhat.com>
Date: Mon, 13 Jan 2014 17:45:45 +0900
In-Reply-To: <20140111160254.GD1131@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sat, 11 Jan 2014 17:02:54 +0100")
Message-ID: <87wqi4b77q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 11 Jan 2014 17:02:54 +0100, Jiri Olsa wrote:
> On Wed, Jan 08, 2014 at 05:46:15PM +0900, Namhyung Kim wrote:
>> It is possble that a callchain has cycles or recursive calls.  In that
>> case it'll end up having entries more than 100% overhead in the
>> output.  In order to prevent such entries, cache each callchain node
>> and skip if same entry already cumulated.

[SNIP]
>> +	node = callchain_cursor_current(&callchain_cursor);
>> +	if (node == NULL)
>> +		return 0;
>
> some leftover? looks like nop..

Ah, right.  I'll get rid of it.

Thanks,
Namhyung
