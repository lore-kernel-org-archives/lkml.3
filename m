Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966401AbaFSXd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:33:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44554 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965786AbaFSXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:33:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/5] perf tools: Factor ui_browser ops out of ui_browser struct
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
	<1403178076-14072-2-git-send-email-jolsa@kernel.org>
	<20140619153851.GE20252@kernel.org>
	<20140619164921.GA31520@krava.brq.redhat.com>
Date: Fri, 20 Jun 2014 08:33:52 +0900
In-Reply-To: <20140619164921.GA31520@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 19 Jun 2014 18:49:21 +0200")
Message-ID: <87vbrw79un.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 19 Jun 2014 18:49:21 +0200, Jiri Olsa wrote:
> On Thu, Jun 19, 2014 at 12:38:51PM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Thu, Jun 19, 2014 at 01:41:12PM +0200, Jiri Olsa escreveu:
>> > Separating ops out of 'struct ui_browser' into
>> > 'struct ui_browser_ops'.
>> 
>> You stated what you did, and that helps in understanding what this patch
>> is about, now we only need to have a paragraph on _why_ this is needed
>> :-)
>
> well.. it's not ;-) but we always separated ops from the
> structs IIRC
>
> I introduced another callback in the early stage of this change,
> but replaced it later.. this remained ;-)
>
> no need to take it.. as I wrote in patch 0:
>
> Patches 1 and 2 are not necessary for the functionality,
> they are just byproducts of another early way I tried,
> but I think they could go in.

Hmm.. I think it should make the ops const, otherwise it makes only a
little sense.


[SNIP]
>> > +static bool ui_browser__filter(struct ui_browser *browser, void *entry)
>> > +{
>> > +	return browser->ops.filter ? browser->ops.filter(browser, entry) :
>> > +				     false;
>> > +}
>> > +
>> >  static struct list_head *
>> >  ui_browser__list_head_filter_entries(struct ui_browser *browser,
>> >  				     struct list_head *pos)
>> >  {
>> >  	do {
>> > -		if (!browser->filter || !browser->filter(browser, pos))
>> > +		if (!ui_browser__filter(browser, pos))

Looks like this can be a separate cleanup.

Thanks,
Namhyung


>> >  			return pos;
>> >  		pos = pos->next;
>> >  	} while (pos != browser->entries);
