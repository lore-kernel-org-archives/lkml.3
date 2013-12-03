Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3LCGC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:02:26 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55429 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3LCGCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:02:25 -0500
X-AuditID: 9c93017e-b7c62ae0000049d9-aa-529d73eafe56
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC] Packaging libtraceevent.so
References: <20131202140322.4ad6a151@gandalf.local.home>
Date: Tue, 03 Dec 2013 15:02:18 +0900
In-Reply-To: <20131202140322.4ad6a151@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 2 Dec 2013 14:03:22 -0500")
Message-ID: <87txeqmpzp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

(also add Jiri to CC list, hi!)

On Mon, 2 Dec 2013 14:03:22 -0500, Steven Rostedt wrote:
> Hi all!
>
> The question has recently come up in Fedora about packaging the
> libtraceevent.so library. Currently there's 4 users of it:
>
>  1) perf
>  2) trace-cmd
>  3) powertop
>  4) rasdaemon
>
> But each have their own copy of the code.
>
> Both perf and trace-cmd are the major developers of the package, and I
> would recommend that they continue using the *.a version, but for those
> tools that are simple users of the library, it would probably make
> sense to have them use libtraceevent.so and remove their copies from
> the code (powertop and rasdaemon).
>
> The question that I'm posing here is, what currently needs to be done
> to have this happen?

I think the most important thing is error handling.  The filter parser
code still has some calls to die().  It should be converted to return
error and appropriate error messages IMHO.  But I didn't check it'd
affect to the end-user APIs though.

And it needs to add plugin APIs before the public release.

>
> Is the API stable enough for a release?

Well, afaics the plugin unregister API should pass pevent as an argument
so that it can unregister individual event/function handlers in it.

Other than that I think it's pretty stable. :)

Thanks,
Namhyung

>
> We probably should have a dot versioning with the .so (ie.
> libtraceevent.so.1)
>
> So what are people's thoughts on this topic?
>
> -- Steve
