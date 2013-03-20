Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3CTN1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:27:33 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47278 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab3CTN1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:27:32 -0400
Date: Wed, 20 Mar 2013 10:27:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 8/9] perf util: Get rid of die() calls in
 trace-data-read.c
Message-ID: <20130320132724.GD1964@ghostprotocols.net>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
 <1363683224-28804-9-git-send-email-namhyung@kernel.org>
 <1363704928.5938.29.camel@gandalf.local.home>
 <87620mj1zz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87620mj1zz.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 20, 2013 at 10:25:52AM +0900, Namhyung Kim escreveu:
> On Tue, 19 Mar 2013 10:55:28 -0400, Steven Rostedt wrote:
> > On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
> >> Convert them to pr_debug() and propagate error code.

> > Shouldn't they be pr_err(). I mean, if the old code would kill the
> > process, why just keep it as a debug output?

> Please see my other reply.

Ditto.
 
> Arnaldo, can you give me your direction/preference?

Yeah, I think that lower levels should emit a debug if it helps
developers and advanced users to remedy or at least understand the
situation.

The builtin-foo.c top level and the [TG]UI routines are the ones that
must emit messages to the user.

- Arnaldo
