Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaAFOpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:45:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:27755 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752949AbaAFOpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:45:23 -0500
Date: Mon, 6 Jan 2014 09:45:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] tools lib traceevent: Add state member to struct
 trace_seq
Message-ID: <20140106094521.2deb8232@gandalf.local.home>
In-Reply-To: <20140106143828.GF1183@krava.brq.redhat.com>
References: <1387445666-7821-1-git-send-email-namhyung@kernel.org>
	<20140103132425.GC1190@krava.brq.redhat.com>
	<871u0lftbh.fsf@sejong.aot.lge.com>
	<20140106143828.GF1183@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014 15:38:28 +0100
Jiri Olsa <jolsa@redhat.com> wrote:


> > I just thought that it's not so important to print message so keeps the
> > error internally until it gets printed.  But I can be wrong as usual...
> 
> I think that if she manages to get one of those errors
> the perf would fail soon anyway.. so it feels better
> to print it out immediately.

Yeah, using a trace_seq after it has been destroyed is a critical
failure, and a major bug. A print to the user console should not be a
problem here. And actually, crashing is not that bad either, as glibc
does the same with using free() of a freed pointer.

But as this error is major, an unwanted print is minor.

-- Steve
