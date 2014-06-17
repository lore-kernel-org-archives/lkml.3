Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaFQIQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:16:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:36218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaFQIQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:16:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="558725220"
Message-ID: <1402992958.3796.69.camel@smile.fi.intel.com>
Subject: Re: [PATCH] lib.c: skip --param parameters
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Date: Tue, 17 Jun 2014 11:15:58 +0300
In-Reply-To: <20140616160238.GA2746@jtriplet-mobl1>
References: <1402915386-28210-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140616160238.GA2746@jtriplet-mobl1>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 09:02 -0700, Josh Triplett wrote:
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

Yes, I will in v2.

> 
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
> > -- 
> > 2.0.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

