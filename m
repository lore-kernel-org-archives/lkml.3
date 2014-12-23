Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaLWHIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:08:38 -0500
Received: from ozlabs.org ([103.22.144.67]:59348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbaLWHIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:08:37 -0500
Message-ID: <1419318514.32430.1.camel@ellerman.id.au>
Subject: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
From: Michael Ellerman <mpe@ellerman.id.au>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Pavel Machek <pavel@ucw.cz>,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Tue, 23 Dec 2014 18:08:34 +1100
In-Reply-To: <20141223042118.GD14960@sejong>
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
	 <20141220204213.GA16705@amd> <20141220170725.776363ac@gandalf.local.home>
	 <20141223042118.GD14960@sejong>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-23 at 13:21 +0900, Namhyung Kim wrote:
> On Sat, Dec 20, 2014 at 05:07:25PM -0500, Steven Rostedt wrote:
> > On Sat, 20 Dec 2014 21:42:13 +0100
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > On Wed 2014-12-10 15:38:27, Michael Ellerman wrote:
> > > > usleep is a Fedoraism, it's not generally available on Debian based
> > > > systems AFAICS.
> > > > 
> > > > GNU sleep accepts a floating point argument, so use that instead.
> > > > 
> > > > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > > 
> > > Could ftrace user interface be enhanced not to need random delays?
> > > 
> > 
> > Not sure what you are talking about. These "random delays" are not for
> > the interface, but instead to force some events to happen and to make
> > sure they did.
> > 
> > As the subject states, this is for "ftracetest" which is the selftests
> > for ftrace.
> > 
> > The usleep is basically a "do something to trigger events", and we
> > don't want to wait long in doing it.
> 
> Right.  AFAIK what ftracetest expects is a scheduler event so it
> doesn't need to be the [u]sleep.

Would /bin/true work in that case?

cheers


