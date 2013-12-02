Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3LBTXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:23:25 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:44639 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3LBTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:23:22 -0500
Date: Mon, 2 Dec 2013 16:23:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
Message-ID: <20131202192315.GA17149@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 02, 2013 at 11:38:20PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> 2013-12-02 (월), 09:33 -0300, Arnaldo Carvalho de Melo:
> > Em Mon, Dec 02, 2013 at 03:53:19PM +0900, Namhyung Kim escreveu:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > 
> > > The --show-time-info option is for displaying elapsed sampling time
> > 
> > Isn't that too long? Can't we use just --time/-t?
> 
> Hmm.. interesting.  Your previous feedback was to use longer and clearer
> option name. :)

> https://lkml.org/lkml/2013/11/18/198
 
Hey, longer and more descriptive names _when required_, in that case I
thought that even being longer --show-task-events would be better, but
here using --show-time-info the 'info' part looks superfluous, at least
to me, hence my suggestion/question :-)

<SNIP>

> > > +++ b/tools/perf/ui/hist.c
> > > @@ -7,19 +7,24 @@
> > >  #include "../util/evsel.h"
> > >  
> > >  /* hist period print (hpp) functions */
> > > +enum hpp_fmt_type {
> > > +	HPP_FMT__PERCENT,
> > > +	HPP_FMT__RAW,
> > > +	HPP_FMT__TIME,
> > > +};
> > 
> > I wonder if we can't make this a bitmask... Does it make sense to print
> > both percent and time, for instance?
> 
> I'm not sure I understood you correctly, but did you mean printing both
> percent and time in a single column?  This enum and the __hpp_fmt()
> function is for a single column.  I can add a new column for time
> percent if you want.

I have not delved into the code, it was just a first impression, lemme
do that now...
 
- Arnaldo
