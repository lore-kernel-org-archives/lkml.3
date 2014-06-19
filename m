Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966413AbaFSXrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:47:12 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50810 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaFSXrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:47:10 -0400
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
Subject: Re: [PATCH 5/5] perf tools: Add report.show-headers config file option
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
	<1403178076-14072-6-git-send-email-jolsa@kernel.org>
	<1403182604.1670.26.camel@leonhard>
	<20140619152843.GB20252@kernel.org>
	<20140619165815.GC31520@krava.brq.redhat.com>
Date: Fri, 20 Jun 2014 08:46:58 +0900
In-Reply-To: <20140619165815.GC31520@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 19 Jun 2014 18:58:15 +0200")
Message-ID: <87mwd8798t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 18:58:15 +0200, Jiri Olsa wrote:
> On Thu, Jun 19, 2014 at 12:28:43PM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Thu, Jun 19, 2014 at 09:56:44PM +0900, Namhyung Kim escreveu:
>> > 2014-06-19 (목), 13:41 +0200, Jiri Olsa:
>> > > Adding report.show-headers config file option to setup
>> > > the appearance of the columns headers.
>> > > 
>> > > Currently columns headers are displayed by default, following
>> > > lines in ~/.perfconfig file will disable that:
>> > > 
>> > >   [report]
>> > >         show-headers = true
>> > 
>> > This also applies to perf top, right?  And it's TUI-specific.  So how
>> > about calling it something like "tui.show-headers"?
>> 
>> Why should it be TUI specific? You either show the headers or you don't,
>> in all UIs.
>> 
>> And also in all tools, I think, so I suggest putting it in some global,
>> for all tools, section in the config file, i.e. something like
>> all.show-headers.
>
> seems like so far we have 'core.' and 'hist.' as non-command specific
> config sections (note '.core' does not hold any options yet)
>
> I can add another 'all.' section

I don't think it's a better name - it's too general.  If we really want
to control all UI behavior I'd rather suggest 'ui.' section name.

Oh, I found that it'd somewhat clash with existing --header(-only)
option in perf report. :-/

Thanks,
Namhyung
