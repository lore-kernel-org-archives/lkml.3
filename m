Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab3CTA5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:57:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44222 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3CTA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:57:38 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-16-5149097f3aee
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/9] perf util: Get rid of write_or_die() from trace-event-info.c
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	<1363683224-28804-4-git-send-email-namhyung@kernel.org>
	<1363703711.5938.20.camel@gandalf.local.home>
	<1363704594.22553.56.camel@laptop>
	<1363705197.5938.31.camel@gandalf.local.home>
	<1363705443.22553.60.camel@laptop>
Date: Wed, 20 Mar 2013 09:57:35 +0900
In-Reply-To: <1363705443.22553.60.camel@laptop> (Peter Zijlstra's message of
	"Tue, 19 Mar 2013 16:04:03 +0100")
Message-ID: <87mwtyj3b4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 16:04:03 +0100, Peter Zijlstra wrote:
> On Tue, 2013-03-19 at 10:59 -0400, Steven Rostedt wrote:
>> On Tue, 2013-03-19 at 15:49 +0100, Peter Zijlstra wrote:
>> > On Tue, 2013-03-19 at 10:35 -0400, Steven Rostedt wrote:
>> > > What about:
>> > >         int err = 0;
>> > > 
>> > >         err += tracing_data_header();
>> > >         err += read_header_files();
>> > >         [...]
>> > > 
>> > >         if (err < 0) {
>> > >                 free(tdata);
>> > >                 tdata = NULL;
>> > >         }
>> > > 
>> > > Also, is the only clean up needed be freeing tdata?
>> > 
>> > I always use err |= foo() and if (err) but I suppose it doesn't matter
>> > the original error codes are lost both ways which doesn't seem to be a
>> > problem here.
>> 
>> err |= foo() is fine too. Both are better that err1, err2, err3, ...,
>> errN :-)
>
> <whinge>
>
> The += thing has a problem where functions can return both positive and
> negative values, you could get an accidental 0 (success) but coupled
> with the proposed <0 test you get a much larger accident space :-)
>
> And while totally hideous the err1..errN case preserves the actual
> return codes if one would actually need those.
>
> </whinge>
>
> /me crawls back under his rock noaw :-)

Sorry for the ugliness, forgot to update the code before sending ;-)

So I'll convert them to err |= foo() style as I don't care about the
actual return value at this time.

Thanks,
Namhyung
