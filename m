Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3B0VMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:12:25 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54872 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3B0VMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:12:24 -0500
Subject: Re: [perf patch] perf doesn't delete /tmp/perf-vdso.so.* file on
 exit
From: Namhyung Kim <namhyung@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20130227130316.GB225@x4>
References: <20130221094544.GA2919@x4> <20130221102748.GB2919@x4>
	 <loom.20130221T191341-303@post.gmane.org>  <20130227130316.GB225@x4>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Feb 2013 06:12:18 +0900
Message-ID: <1361999538.1712.15.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-02-27 (수), 14:03 +0100, Markus Trippelsdorf:
> On 2013.02.21 at 18:19 +0000, Namhyung Kim wrote:
> > Markus Trippelsdorf <markus <at> trippelsdorf.de> writes:
> > > 
> > > perf top doesn't unlink /tmp/perf-vdso.so.* on exit.
> > > Fix this by calling vdso__exit() before exit(0).
> > 
> > > @@ -602,6 +603,7 @@ static void *display_thread_tui(void *arg)
> > >  				      &top->session->header.env);
> > > 
> > >  	exit_browser(0);
> > > +	vdso__exit();
> > >  	exit(0);
> > >  	return NULL;
> > >  }
> > 
> > I don't think it's enough - it doesn't cover all exit paths.
> > I'd suggest making it to use atexit/on_exit().
> 
> The issue is fixed by commit 11859e821761.
> 

Ah, right.  It's much better. :)

Thanks,
Namhyung


