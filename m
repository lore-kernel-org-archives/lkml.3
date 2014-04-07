Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaDGFPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:15:25 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:49652 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaDGFPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:15:23 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jmario@redhat.com,
        fowles@inreach.com
Subject: Re: [PATCH 3/4] perf, callchain: Add generic report parse callchain callback function
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
	<1395689577-214654-4-git-send-email-dzickus@redhat.com>
	<87zjk3x8dv.fsf@sejong.aot.lge.com> <20140404193119.GI8488@redhat.com>
	<20140406121129.GB1164@krava.brq.redhat.com>
Date: Mon, 07 Apr 2014 14:15:21 +0900
In-Reply-To: <20140406121129.GB1164@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 6 Apr 2014 14:11:29 +0200")
Message-ID: <87r459yb2u.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri and Don,

On Sun, 6 Apr 2014 14:11:29 +0200, Jiri Olsa wrote:
> On Fri, Apr 04, 2014 at 03:31:19PM -0400, Don Zickus wrote:
>> On Thu, Apr 03, 2014 at 02:57:32PM +0900, Namhyung Kim wrote:
>> > On Mon, 24 Mar 2014 15:32:56 -0400, Don Zickus wrote:
>> > > This takes the parse_callchain_opt function and copies it into the
>> > > callchain.c file.  Now the c2c tool can use it too without duplicating.
>> > >
>> > > Signed-off-by: Don Zickus <dzickus@redhat.com>
>> > > ---
>> > >  tools/perf/util/callchain.c | 83 +++++++++++++++++++++++++++++++++++++++++++++
>> > >  tools/perf/util/callchain.h |  1 +
>> > >  2 files changed, 84 insertions(+)
>> > >
>> > > diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
>> > > index 8d9db45..2320678 100644
>> > > --- a/tools/perf/util/callchain.c
>> > > +++ b/tools/perf/util/callchain.c
>> > > @@ -25,6 +25,89 @@
>> > >  
>> > >  __thread struct callchain_cursor callchain_cursor;
>> > >  
>> > > +int
>> > > +report_parse_callchain_opt(const char *arg)
>> > 
>> > As it eliminated any dependency to the report code, the name can omit
>> > 'report' as well.
>> 
>> Hmm, shrinking this down to 'parse_callchain_opt' seems to conflict with
>> builtin-top.c's defintion which is a wrapper around
>> record_parse_callchain_opt.
>> 
>> I can modify builtin-top.c's defintion to top_parse_callchain_opt, but do
>> we want to make the function parse_callchain_opt name more obvious that it is
>> for 'report' style parsing (which means it looks for the embedded
>> callchain flag)?  Vs. the record_parse_callchain_opt function, which is for
>> setting up the callchain flag?
>
> that sounds good to me.. (record|report)_parse_callchain_opt

Agreed.  Maybe parse_callchain_(record|report)_opt?

Thanks,
Namhyung
