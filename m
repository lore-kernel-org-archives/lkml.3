Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3K0IN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:13:58 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48059 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3K0IN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:13:56 -0500
X-AuditID: 9c93017d-b7b24ae000002834-da-5295a9c383cb
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 17/22] perf tools: Add build and install plugins targets
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-18-git-send-email-jolsa@redhat.com>
	<1385134068.1747.105.camel@leonhard>
	<20131125145144.GG3161@krava.brq.redhat.com>
Date: Wed, 27 Nov 2013 17:13:54 +0900
In-Reply-To: <20131125145144.GG3161@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 25 Nov 2013 15:51:44 +0100")
Message-ID: <87vbzeqn25.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 25 Nov 2013 15:51:44 +0100, Jiri Olsa wrote:
> On Sat, Nov 23, 2013 at 12:27:48AM +0900, Namhyung Kim wrote:
>> 2013-11-21 (목), 12:01 +0100, Jiri Olsa:
>> > Adding 'plugins' target along with the libtraceevent.a,
>> > so plugins are built together with traceevent library.
>> > 
>> > Adding 'install-traceevent-plugins' Makefile install target,
>> > instructing perf to install plugins into:
>> >   $(HOME)/libexec/perf-core/traceevent/plugins
>> >     - if installed localy under $HOME
>> >   $(DESTDIR)/$(prefix)/$(perfexecdir)/traceevent/plugins
>> >     - if installed globally
>> 
>> [SNIP]
>> > --- a/tools/perf/config/Makefile
>> > +++ b/tools/perf/config/Makefile
>> > @@ -578,6 +578,7 @@ else
>> >  lib = lib
>> >  endif
>> >  libdir = $(prefix)/$(lib)
>> > +plugindir=$(perfexecdir)/traceevent/plugins
>> 
>> Hmm.. it puts traceevent plugins under the perf directory.  But I don't
>> think it's a good idea since libtraceevent can be used independently.
>> 
>> What about something like this?
>> 
>>   plugindir = $(perfexecdir)/../traceevent/plugins
>
> this is where trace-cmd stores them:
>
>   $(HOME)/.trace-cmd/plugins
>   $(prefix)/$(libdir)/trace-cmd/plugins
>
> but I guess we want global place to install plugins,
> the traceevent by default uses:
>
>   $(HOME)/.traceevent/plugins
>   $(prefix)/lib/traceevent/plugins
>
> How about that?

Looks good to me.

Thanks,
Namhyung
