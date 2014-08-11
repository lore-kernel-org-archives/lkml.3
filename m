Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaHKHpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:45:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:38640 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaHKHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:45:43 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf script: Fix possible memory leaks
References: <1406881486-5789-1-git-send-email-namhyung@kernel.org>
	<53DB7AC3.3030207@intel.com>
Date: Mon, 11 Aug 2014 16:45:41 +0900
In-Reply-To: <53DB7AC3.3030207@intel.com> (Adrian Hunter's message of "Fri, 01
	Aug 2014 14:32:19 +0300")
Message-ID: <87vbpzfp0a.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Fri, 01 Aug 2014 14:32:19 +0300, Adrian Hunter wrote:
> On 1/08/2014 11:24 a.m., Namhyung Kim wrote:
>> Some paths in perf script don't call perf_session__delete() after
>> creating a new session.
>>

[SNIP]
>> -	perf_session__delete(session);
>>   	cleanup_scripting();
>> +out_delete:
>> +	perf_session__delete(session);
>
> Some of the db-export scripting I do relies on the session
> being deleted before the script is stopped.  I would prefer
> the original order i.e. perf_session__delete() then
> cleanup_scripting()

Okay, I'll fix it and send v2.

Thanks,
Namhyung
