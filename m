Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3LDN3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:29:42 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:33919 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3LDN3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:29:40 -0500
Date: Wed, 4 Dec 2013 10:29:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 22/28] tools lib traceevent: Remove malloc_or_die from
 event-plugin.c
Message-ID: <20131204132932.GE6359@ghostprotocols.net>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
 <1386076182-14484-23-git-send-email-jolsa@redhat.com>
 <20131203111601.540ed5f7@gandalf.local.home>
 <20131204092934.GB1219@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204092934.GB1219@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 04, 2013 at 10:29:34AM +0100, Jiri Olsa escreveu:
> On Tue, Dec 03, 2013 at 11:16:01AM -0500, Steven Rostedt wrote:
> > On Tue,  3 Dec 2013 14:09:36 +0100 Jiri Olsa <jolsa@redhat.com> wrote:

> > > Removing malloc_or_die calls from event-plugin.c,
> > > replacing them with standard malloc and error path.

> > > Suggested-by: Namhyung Kim <namhyung@kernel.org>

> > > +++ b/tools/lib/traceevent/event-plugin.c
> > > @@ -47,7 +47,11 @@ load_plugin(struct pevent *pevent, const char *path,

> > > -	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
> > > +	plugin = malloc(strlen(path) + strlen(file) + 2);
> > > +	if (!plugin) {
> > > +		warning("could not allocate plugin memory\n");
> > > +		return;

> > This should be changed to return an error code. Yes it will require
> > other places to change for that update as well.

> Any chance this could be a separated feature? ;-)

> AFACIS there's no technical problem with the current code.  If the
> load_plugin fails (due to ENOMEM or interface error) it's not added on
> the plugin_list, which is the output/handle of plugin interface (and
> there's warning ;-)).
 
> I think we need some complex/unified error handling for the whole
> library and add that globally.

Yeah, I also have some reservations about adding more globals (the
trace_event stuff just to associate a plugins list with pevent, probably
pevent should have that list, haven't looked 100% at the code), but in
general probably this patchset is OK, I think we should take it in and
then address those other problems in a followup patchset, d'accord?

- Arnaldo
