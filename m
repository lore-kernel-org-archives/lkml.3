Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab3BVWF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:05:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3BVWF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:05:58 -0500
Date: Fri, 22 Feb 2013 14:05:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Improve CamelCase test for Page
Message-Id: <20130222140556.509fbbee.akpm@linux-foundation.org>
In-Reply-To: <1361570508.5608.10.camel@thor.lan>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
	<1361566784.2030.6.camel@joe-AO722>
	<1361570508.5608.10.camel@thor.lan>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 17:01:48 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> On Fri, 2013-02-22 at 12:59 -0800, Joe Perches wrote:
> > Add the ClearPage/SetPage/TestClearPage/TestSetPage
> > variants to the not reported Page CamelCase variables.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  scripts/checkpatch.pl | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 747bcd7..8a32306 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2930,7 +2930,7 @@ sub process {
> >  			my $var = $1;
> >  			if ($var !~ /$Constant/ &&
> >  			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> > -			    $var !~ /^Page[A-Z]/ &&
> > +			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
> >  			    !defined $camelcase{$var}) {
> >  				$camelcase{$var} = 1;
> >  				WARN("CAMELCASE",
> > 
> 
> In a recent patch, checkpatch gave this warning.
> 
> WARNING: Avoid CamelCase: <tty->SAK_work>
> #35: FILE: drivers/tty/tty_io.c:1475:
> +	flush_work(&tty->SAK_work);

If we start whitelisting these things, it will never end.

My (cruelly spurned) suggestion for this check is to grep the affected
files to see if the symbol is already present and if so, don't warn.

Or just revert the whole thing.  I get tons of camelcase warnings, and
they're always unuseful/incorrect/ignored.

