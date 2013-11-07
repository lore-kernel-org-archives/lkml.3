Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3KGGoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 01:44:25 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54788 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3KGGoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 01:44:19 -0500
X-AuditID: 9c930197-b7c0bae0000007bd-43-527b36c16a4d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/10] perf hists: Consolidate __hists__add_*entry()
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
	<1383682201-19399-2-git-send-email-acme@infradead.org>
	<20131105215243.GA8303@sdfg.com.ar>
	<20131106134210.GA2711@ghostprotocols.net>
Date: Thu, 07 Nov 2013 15:44:17 +0900
In-Reply-To: <20131106134210.GA2711@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 6 Nov 2013 10:42:10 -0300")
Message-ID: <87mwlgww1q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 6 Nov 2013 10:42:10 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 05, 2013 at 09:52:43PM +0000, Rodrigo Campos escreveu:
>> On Tue, Nov 05, 2013 at 05:09:52PM -0300, Arnaldo Carvalho de Melo wrote:
>> > @@ -486,15 +425,15 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
>> >  		.stat = {
>> > -			.period	= period,
>> >  			.nr_events = 1,
>> > +			.period	= period,
>> >  			.weight = weight,
>> >  		},
>
>> Isn't this seems unrelated and unneeded ?
>
>> The "period" field is before the "nr_events" field in the struct, so maybe is
>> more clear to leave it as it was ?  The actual relative order (it has some more
>> fields) in the struct is: period, weigth, nr_events. Might be better if they
>> match that order here ? Although not sure since we are using the fields with
>> name and is clear enough.
>
> Yeah, this shouldn't be there, I thought about fixing this up to reduce
> the patch size, but ended up being lenient.
>
> Namhyung, please avoid such unneeded patch churn :-)

Okay, I'll keep it in mind.

Thanks,
Namhyung
