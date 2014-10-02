Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaJBVzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:55:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJBVzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:55:35 -0400
Date: Thu, 2 Oct 2014 22:55:31 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] acct: fix build warning when ACCT_VERSION != 3
Message-ID: <20141002215531.GA5259@hercules>
References: <20141001230653.GA25541@hercules>
 <20141002140945.6f8ea8fcad9649819cb457e5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141002140945.6f8ea8fcad9649819cb457e5@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:09:45PM -0700, Andrew Morton wrote:
> On Thu, 2 Oct 2014 00:06:53 +0100 Luis Henriques <luis.henriques@canonical.com> wrote:
> 
> > struct pid_namespace *ns is used only when ACCT_VERSION is 3.
> > 
> > kernel/acct.c:475:24: warning: unused variable 'ns' [-Wunused-variable]
> > 
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> > ---
> >  kernel/acct.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/kernel/acct.c b/kernel/acct.c
> > index b4c667d22e79..5f277f5c5e29 100644
> > --- a/kernel/acct.c
> > +++ b/kernel/acct.c
> > @@ -472,7 +472,9 @@ static void do_acct_process(struct bsd_acct_struct *acct)
> >  	acct_t ac;
> >  	unsigned long flim;
> >  	const struct cred *orig_cred;
> > +#if ACCT_VERSION == 3
> >  	struct pid_namespace *ns = acct->ns;
> > +#endif
> >  	struct file *file = acct->file;
> >  
> >  	/*
> 
> It's always a good idea to check linux-next.  This has been addressed by
> http://ozlabs.org/~akpm/mmots/broken-out/acct-eliminate-compile-warning.patch
> http://ozlabs.org/~akpm/mmots/broken-out/acct-eliminate-compile-warning-fix.patch
> 
> 

Ah, awesome!  I missed these patches.  Thanks Andrew.

Cheers,
--
Luís
