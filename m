Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3LCEdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 23:33:15 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45387 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3LCEdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 23:33:14 -0500
X-AuditID: 9c93017e-b7c62ae0000049d9-ac-529d5f087279
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] perf tools: Record sampling time for each entry
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
	<1385967199-3759-3-git-send-email-namhyung@kernel.org>
	<20131202123918.GE2371@ghostprotocols.net>
	<1385996264.1710.26.camel@leonhard>
	<20131202184905.GA14254@ghostprotocols.net>
Date: Tue, 03 Dec 2013 13:33:12 +0900
In-Reply-To: <20131202184905.GA14254@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 2 Dec 2013 15:49:05 -0300")
Message-ID: <877gbmo8on.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 2 Dec 2013 15:49:05 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 02, 2013 at 11:57:44PM +0900, Namhyung Kim escreveu:
>> 2013-12-02 (월), 09:39 -0300, Arnaldo Carvalho de Melo:
>> > Em Mon, Dec 02, 2013 at 03:53:18PM +0900, Namhyung Kim escreveu:
>> > > From: Namhyung Kim <namhyung.kim@lge.com>
>> > > 
>> > > Calculate elapsed time for each sample and record it.  The elapsed
>> > > time is a diff between current sample->time and previous sample->time
>> > > which was saved for each evsel and cpu.
>> > 
>> > Can you elaborate on why this is interesting to have? What meaning can
>> > one get from the sample->time - prev_sample->time?
>> > 
>> > We need clearer changelogs...
>> 
>> Sorry about that.. how about this?
>> 
>> Sometimes users might want see a relation between value and time of a
>> sample.  And the time itself is a very important information to have.
>> As the sample->period value is a diff of counter values between samples
>> it might make sense to add time-diff between samples into a hist entry.
>> 
>> To do that, calculate elapsed time for each sample and record it.  The
>> elapsed time is the diff between current sample->time and previous
>> sample->time which was saved for each evsel.
>
> Much better! Thanks, and please consider adding this to the man page as
> well, in a followup patch.

Okay.

>
> I'll add the above explanation to the patch, that, as I could read seems
> to not have had any nak, right?

Right.  So will you merge this into your tree with new changelog?  I
found that it break build on an old system due to shadowing 'time'
symbol with local one.

I'll send v2 soon with a fix.

Thanks,
Namhyung
