Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaE3E6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:58:08 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:35478 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaE3E6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:58:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCHSET 00/27] perf tools: Add support to accumulate hist periods (v11)
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
	<20140529135859.GF1177@krava.brq.redhat.com>
Date: Fri, 30 May 2014 13:58:04 +0900
In-Reply-To: <20140529135859.GF1177@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 29 May 2014 15:59:00 +0200")
Message-ID: <87fvjrg8wz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 15:59:00 +0200, Jiri Olsa wrote:
> On Thu, May 29, 2014 at 12:58:03PM +0900, Namhyung Kim wrote:
>> Hello,
>> 
>> This is a new attempt to implement cumulative hist period report.
>> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
>> rewrote it from scratch.
>> 
>> This patchset basically adds period in a sample to every node in the
>> callchain.  A hist_entry now has an additional fields to keep the
>> cumulative period if --children option is given on perf report.
>> 
>> I changed the option as a separate --children and added a new
>> "Children" column (and renamed the default "Overhead" column into
>> "Self").  The output will be sorted by children (cumulative) overhead
>> for now.  It also adds 'overhead_children' field to -F/--fields option
>> to be selected by user and it'll show you "N/A" if the cumulation is
>> not supported (due to missing callchain).
>> 
>> I added Tested-by from Rodrigo Campos since this version is basically
>> rebase of previous series + bugfix.  But it still needs to be tested
>> more intensively IMHO.  Also note that, this will change default
>> behavior of perf report/top if callchain is recorded, so might confuse
>> old users.  Let's see how many of them come to shout. :)  I think we
>> need to merge Jiri's TUI column header patch at least.
>> 
>> 
>>  * changes in v11:
>>   - factor out hists__inc_nr_samples  (Jiri)
>>   - remove unrelated change  (Jiri)
>>   - disable accumulation on branch or mem mode
>>   - slightly refactor hist_iter code
>
> apart from that comment I sent, I think it's ready to go in

Thanks!  As I said, I've pushed v12 to korg with change you commented.

And I also found that the overhead in perf_hpp__should_skip() is
strangely high.. will check your patch.

Thanks,
Namhyung
