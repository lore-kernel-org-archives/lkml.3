Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaFPXsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:48:55 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:57466 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaFPXsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:48:53 -0400
Date: Mon, 16 Jun 2014 16:48:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH] lib.c: skip --param parameters
In-Reply-To: <20140616160238.GA2746@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.02.1406161647510.21018@chino.kir.corp.google.com>
References: <1402915386-28210-1-git-send-email-andriy.shevchenko@linux.intel.com> <20140616160238.GA2746@jtriplet-mobl1>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Josh Triplett wrote:

> On Mon, Jun 16, 2014 at 01:43:06PM +0300, Andy Shevchenko wrote:
> > Very dumb patch to just skip --param allow-store-data-races=0 introduced in
> > newest Linux kernel buildsystem.
> > 
> > Actually the option is present in few GCC versions and probably should be
> > handled properly.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> As far as I can tell, this seems to only handle "--param arg"; however,
> according to the thread on LKML, GCC handles --param=arg as well.  Could
> you please handle that variant too?
> 

This is only from linux-next and not Linus's tree, correct?

Is this still necessary since the "./Makefile: tell gcc optimizer to never 
introduce new data races" patch has been removed from -mm due to failures?

See http://marc.info/?l=linux-mm-commits&m=140295825623471

> >  lib.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/lib.c b/lib.c
> > index bf3e91c..e56037b 100644
> > --- a/lib.c
> > +++ b/lib.c
> > @@ -673,6 +673,12 @@ static char **handle_version(char *arg, char **next)
> >  	exit(0);
> >  }
> >  
> > +static char **handle_param(char *arg, char **next)
> > +{
> > +	++next;
> > +	return ++next;
> > +}
> > +
> >  struct switches {
> >  	const char *name;
> >  	char **(*fn)(char *, char **);
> > @@ -681,6 +687,7 @@ struct switches {
> >  static char **handle_long_options(char *arg, char **next)
> >  {
> >  	static struct switches cmd[] = {
> > +		{ "param", handle_param },
> >  		{ "version", handle_version },
> >  		{ NULL, NULL }
> >  	};
