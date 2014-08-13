Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaHMEw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:52:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46596 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaHMEwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 00:52:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCH 1/2] perf top: Fix -z option behavior
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
	<53EA6495.4010600@gmail.com>
Date: Wed, 13 Aug 2014 13:52:51 +0900
In-Reply-To: <53EA6495.4010600@gmail.com> (David Ahern's message of "Tue, 12
	Aug 2014 13:01:41 -0600")
Message-ID: <87vbpxdm8s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 12 Aug 2014 13:01:41 -0600, David Ahern wrote:
> On 8/12/14, 2:16 AM, Namhyung Kim wrote:
>> The current -z option does almost nothing.  It doesn't zero the
>> existing samples so that we can see profiles of exited process after
>> last refresh.  It seems it only affects annotation.
>>
>> This patch clears existing entries before processing if -z option is
>> given.  For this original decaying logic also moved before processing.
>
> This option was broken somewhere recently. I am on vacation for
> another week, so I can't do a git bisect myself but I recall it worked
> a year or so ago. Try v3.4 as a start point.

Are you sure?  I don't recall seeing any big change in this area so I
guess the problem existed since long time ago.  In fact I couldn't find
a logic to zero/clear out existing hist entries in a hists..

Thanks,
Namhyung
