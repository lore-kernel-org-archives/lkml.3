Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3KYHdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 02:33:42 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56219 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3KYHdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 02:33:40 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-de-5292fd5358b3
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 01/22] tools lib traceevent: Add plugin support
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-2-git-send-email-jolsa@redhat.com>
	<1385129826.1747.22.camel@leonhard>
	<20131123031219.5426ffa9@gandalf.local.home>
Date: Mon, 25 Nov 2013 16:33:39 +0900
In-Reply-To: <20131123031219.5426ffa9@gandalf.local.home> (Steven Rostedt's
	message of "Sat, 23 Nov 2013 03:12:19 -0500")
Message-ID: <87k3fxrl4c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov 2013 03:12:19 -0500, Steven Rostedt wrote:
> On Fri, 22 Nov 2013 23:17:06 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> > 
>> [SNIP[
>> > +static void
>> > +load_plugin(struct pevent *pevent, const char *path,
>> > +	    const char *file, void *data)
>> > +{
>> > +	struct plugin_list **plugin_list = data;
>> > +	pevent_plugin_load_func func;
>> > +	struct plugin_list *list;
>> > +	const char *alias;
>> > +	char *plugin;
>> > +	void *handle;
>> > +
>> > +	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
>> 
>> I'd like not to see this malloc_or_die() anymore in a new code.  Just
>> returning after showing a warning looks enough here.
>
> Yeah I agree. This is a relic from my code. I think it's OK to add
> here, as it is pretty much direct port of my code, and then we can just
> add a patch against it to remove it.

Okay.  I agree that it'd be better to make them separate patches.

>
>> 
>> > +
>> > +	strcpy(plugin, path);
>> > +	strcat(plugin, "/");
>> > +	strcat(plugin, file);
>> > +
>> > +	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
>> 
>> Why RTLD_NOW and RTLD_GLOBAL?  Hmm.. maybe using _NOW is needed to
>> prevent a runtime error, but not sure why _GLOBAL is needed.
>
> Yes, we want to make sure all symbols defined are available at time of
> load, otherwise bail out.
>
>> 
>> IIUC _GLOBAL is for exporting symbols to *other libraries*.  Is it
>> intended for this plugin support?
>
> That was the plan. To have one plugin supply a set of functions that
> other plugins may use. That is what GLOBAL is for, right?  I don't
> recall if I every did this, but it was something I wanted for future
> work.
>
> Now if we don't need it, we could remove it, but is it bad to have?

I might be slow down symbol resolution of new plugins tiny bit.  But I
don't think it's a real problem as its effect will be negligible.

I don't object the code but just want to know your intention. :)

Thanks,
Namhyung
