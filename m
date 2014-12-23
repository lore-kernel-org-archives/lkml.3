Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaLWEUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:20:40 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42425 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaLWEUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:20:39 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 23 Dec 2014 13:21:18 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pavel Machek <pavel@ucw.cz>, Michael Ellerman <mpe@ellerman.id.au>,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
Message-ID: <20141223042118.GD14960@sejong>
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
 <20141220204213.GA16705@amd>
 <20141220170725.776363ac@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141220170725.776363ac@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 05:07:25PM -0500, Steven Rostedt wrote:
> On Sat, 20 Dec 2014 21:42:13 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Wed 2014-12-10 15:38:27, Michael Ellerman wrote:
> > > usleep is a Fedoraism, it's not generally available on Debian based
> > > systems AFAICS.
> > > 
> > > GNU sleep accepts a floating point argument, so use that instead.
> > > 
> > > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > 
> > Could ftrace user interface be enhanced not to need random delays?
> > 
> 
> Not sure what you are talking about. These "random delays" are not for
> the interface, but instead to force some events to happen and to make
> sure they did.
> 
> As the subject states, this is for "ftracetest" which is the selftests
> for ftrace.
> 
> The usleep is basically a "do something to trigger events", and we
> don't want to wait long in doing it.

Right.  AFAIK what ftracetest expects is a scheduler event so it
doesn't need to be the [u]sleep.

Thanks,
Namhyung
