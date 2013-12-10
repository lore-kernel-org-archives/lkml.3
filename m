Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3LJCIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:08:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:29542 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750787Ab3LJCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:08:23 -0500
Date: Mon, 9 Dec 2013 21:08:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 04/14] tools lib traceevent: Get rid of malloc_or_die()
 allocate_arg()
Message-ID: <20131209210821.793758c6@gandalf.local.home>
In-Reply-To: <874n6hlcur.fsf@sejong.aot.lge.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-5-git-send-email-namhyung@kernel.org>
	<20131209110519.7e9fd95c@gandalf.local.home>
	<874n6hlcur.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 10:21:48 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

 
> >
> > Also, I prefer if (!arg) over if (arg == NULL), but I'm not going to
> > fight over that ;-)
> 
> Yeah, it's about preference.  I can do it your way from now on if you
> want while as you can see it's more error-prone - but no, I didn't do it
> intentionally because of that. ;-)

I'm not really that picky. When I code, I use the (!arg) version. I
haven't had an inverse bug due to it in a long time. But I've fixed
others that have done it, so I understand the rational for it.

What I refuse to accept is the "if (NULL == arg)" notation. That just
makes it hard to read, and compilers are smart enough today to detect
the "if (arg = NULL)" bugs.

-- Steve
