Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3BVXIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:08:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3BVXIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:08:48 -0500
Date: Fri, 22 Feb 2013 15:08:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Joe Perches <joe@perches.com>, Peter Hurley <peter@hurleysoftware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Improve CamelCase test for Page
Message-Id: <20130222150847.4562266b.akpm@linux-foundation.org>
In-Reply-To: <CAKocOONj+gEcBXZJXGqoY00mcUf5WpLo7j7JF-S20UZED+pLCA@mail.gmail.com>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
	<1361566784.2030.6.camel@joe-AO722>
	<1361570508.5608.10.camel@thor.lan>
	<1361571667.2030.13.camel@joe-AO722>
	<CAKocOONj+gEcBXZJXGqoY00mcUf5WpLo7j7JF-S20UZED+pLCA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 15:57:16 -0700
Shuah Khan <shuahkhan@gmail.com> wrote:

> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 747bcd7..e08e9f6 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2929,8 +2929,8 @@ sub process {
> >                 while ($line =~ m{($Constant|$Lval)}g) {
> >                         my $var = $1;
> >                         if ($var !~ /$Constant/ &&
> > -                           $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> > -                           $var !~ /^Page[A-Z]/ &&
> > +                           $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
> > +                           $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ && &&
> >                             !defined $camelcase{$var}) {
> >                                 $camelcase{$var} = 1;
> >                                 WARN("CAMELCASE",
> >
> >
> 
> What are the guidelines on camelcase warnings on patches. A recent one
> I ran into is on a variable in a structure and fixing it would require
> changing the original variable.
> 
> WARNING: Avoid CamelCase: <cp->Header.SGList>
> #67: FILE: drivers/scsi/hpsa.c:1409:
> +		cp->Header.SGList = 0;
> 
> WARNING: Avoid CamelCase: <cp->Header.SGTotal>
> #68: FILE: drivers/scsi/hpsa.c:1410:
> +		cp->Header.SGTotal = 0;
> 
> total: 0 errors, 2 warnings, 11 lines checked
> 
> One would have to change a large portion of the code to fix it. In
> such cases, do we ignore this warning?

Yes, ignore the warning.  In my experience this is always the case,
and it happens often.

