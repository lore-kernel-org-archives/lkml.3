Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaHSGHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:07:51 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48421 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaHSGHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:07:49 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [RFC/PATCH 1/2] perf top: Fix -z option behavior
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
	<20140813202756.GK2718@kernel.org>
Date: Tue, 19 Aug 2014 15:07:47 +0900
In-Reply-To: <20140813202756.GK2718@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Wed, 13 Aug 2014 17:27:56 -0300")
Message-ID: <87d2bxc8r0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 17:27:56 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Aug 12, 2014 at 05:16:05PM +0900, Namhyung Kim escreveu:
>> The current -z option does almost nothing.  It doesn't zero the
>> existing samples so that we can see profiles of exited process after
>> last refresh.  It seems it only affects annotation.
>> 
>> This patch clears existing entries before processing if -z option is
>> given.  For this original decaying logic also moved before processing.
>
> So, this is two things bolted into one, i.e. it is not stated here why
> decaying needs to be done before resorting. I bet its because since
> we're zeroing everything, no need to decay anything, right?

Exactly.

>
> Stating more clearly what is the intent and the reason for changes helps
> reviewing.

Yep, will do better next time.

>
> Anyway, will add a note about that and apply the change.

Thank you!

>
> Also, the delete entries thing could zero total stats in struct hists,
> which is not a problem currently, because, IIRC, the collapse/resort
> logic will do that when it rotates the hists, but if we ever want to
> just delete events and then add a bunch of events without resorting, we
> will end up with bogus stats that will have the sum of the old events
> stats with the new ones.

Right.  I'll send the fix.

Thanks,
Namhyung
