Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3CSPEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:04:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55045
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756831Ab3CSPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:04:06 -0400
Message-ID: <1363705443.22553.60.camel@laptop>
Subject: Re: [PATCH 3/9] perf util: Get rid of write_or_die() from
 trace-event-info.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 16:04:03 +0100
In-Reply-To: <1363705197.5938.31.camel@gandalf.local.home>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-4-git-send-email-namhyung@kernel.org>
	 <1363703711.5938.20.camel@gandalf.local.home>
	 <1363704594.22553.56.camel@laptop>
	 <1363705197.5938.31.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 10:59 -0400, Steven Rostedt wrote:
> On Tue, 2013-03-19 at 15:49 +0100, Peter Zijlstra wrote:
> > On Tue, 2013-03-19 at 10:35 -0400, Steven Rostedt wrote:
> > > What about:
> > >         int err = 0;
> > > 
> > >         err += tracing_data_header();
> > >         err += read_header_files();
> > >         [...]
> > > 
> > >         if (err < 0) {
> > >                 free(tdata);
> > >                 tdata = NULL;
> > >         }
> > > 
> > > Also, is the only clean up needed be freeing tdata?
> > 
> > I always use err |= foo() and if (err) but I suppose it doesn't matter
> > the original error codes are lost both ways which doesn't seem to be a
> > problem here.
> 
> err |= foo() is fine too. Both are better that err1, err2, err3, ...,
> errN :-)

<whinge>

The += thing has a problem where functions can return both positive and
negative values, you could get an accidental 0 (success) but coupled
with the proposed <0 test you get a much larger accident space :-)

And while totally hideous the err1..errN case preserves the actual
return codes if one would actually need those.

</whinge>

/me crawls back under his rock noaw :-)

