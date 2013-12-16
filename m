Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3LPMlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:41:06 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:41513 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3LPMk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:40:58 -0500
Date: Mon, 16 Dec 2013 09:40:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Get rid of die() in some
 string conversion funcitons
Message-ID: <20131216124051.GA3598@ghostprotocols.net>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
 <1386833777-3790-14-git-send-email-namhyung@kernel.org>
 <20131212184147.GE8164@ghostprotocols.net>
 <87y53phah9.fsf@sejong.aot.lge.com>
 <20131213145204.GC29275@ghostprotocols.net>
 <87sitth03c.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sitth03c.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 16, 2013 at 01:49:11PM +0900, Namhyung Kim escreveu:
> On Fri, 13 Dec 2013 11:52:04 -0300, Arnaldo Carvalho de Melo wrote:
> > All the rest is ok, so its just the malloc + strcpy that remains to be
> > converted, do you want me to do it?
 
> Hmm.. did you mean like this?

> 		str = NULL;
>                 if (val)
>                 	asprintf(&str, "TRUE");
>                 else
>                 	asprintf(&str, "FALSE");
>                 return str;

More compact:

	if (asprintf(&str, "%s", val ? "TRUE" : "FALSE") < 0)
		// error handling path

At that point str already is set to NULL.

- Arnaldo
