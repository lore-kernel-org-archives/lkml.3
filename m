Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3LBUZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:25:11 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:37267 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3LBUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:25:06 -0500
Date: Mon, 2 Dec 2013 17:24:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
Message-ID: <20131202202459.GF17149@ghostprotocols.net>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
 <1385967199-3759-2-git-send-email-namhyung@kernel.org>
 <20131202124527.GB22212@gmail.com>
 <20131202125709.GA22404@gmail.com>
 <1385999009.1710.72.camel@leonhard>
 <20131202163620.GC27781@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131202163620.GC27781@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 02, 2013 at 05:36:20PM +0100, Ingo Molnar escreveu:
> * Namhyung Kim <namhyung@kernel.org> wrote:
> > 2013-12-02 (월), 13:57 +0100, Ingo Molnar:
> > > So basically, in the end I think it should be possible to have the 
> > > following behavior:

> > >    perf record -a -e cycles sleep 1

> > >    perf report stat              # Reports as if we ran: 'perf stat -a -e cycles sleep 1'
> > >    perf report                   # Reports the usual histogram

> > >    perf report --stat            # Reports the perf stat output and the histogram

> > > or so.

> > I don't think we need both of 'perf report stat' and 'perf report
> > --stat'.  At least it looks somewhat confusing to users IMHO.
 
> Okay. Maybe the --stat option would be the more logical choice, 
> because '--' options can be added arbitrarily, while it would be weird 
> to add multiple subcommand options.
 
> So basically there would be two options:
 
>    --show-stat         [--no-show-stat]
>    --show-histogram    [--no-show-histogram]
 
> Today --show-histogram is the only one enabled by default.
 
> Running:
 
>    perf report --no-show-histogram --show-stat

Why not:

perf stat -i perf.data

and make it be an optional argument, so plain:

perf stat -i

would process perf.data, i.e. would get the samples, accrue the periods,
calculate the time, etc and then present it as 'perf stat <some
target>'.

Right now 'perf stat -i' i used for '--no-inherit', perhaps we can just
have --no-inherit have no short option and grab -i to have the same
meaning as in 'report', 'script', etc.

- Arnaldo
