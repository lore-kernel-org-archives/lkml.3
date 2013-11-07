Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab3KGFJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:09:51 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:57364 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751022Ab3KGFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:09:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3870:3871:3872:3873:3874:4321:4605:5007:6119:7652:7903:10010:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: place75_8f7385f898546
X-Filterd-Recvd-Size: 2722
Message-ID: <1383800991.7940.51.camel@joe-AO722>
Subject: Re: [trivial PATCH] module.h: Remove unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 06 Nov 2013 21:09:51 -0800
In-Reply-To: <87zjph55px.fsf@rustcorp.com.au>
References: <1383685095.4387.45.camel@joe-AO722>
	 <87zjph55px.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 12:32 +1030, Rusty Russell wrote:
> Joe Perches <joe@perches.com> writes:
> > This semicolon isn't necessary, remove it.
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> This is a terrible description.  Really bad.

I'd've preferred no description.

> First, it just repeats the subject, with more words.

Which others have demanded.

> Second, it gives me no indication that you've done a grep to make sure
> noone is abusing the macro, so I can't apply it without doing that check
> myself.

That's a trust issue.
I've done it.  It isn't necessary.
The other #define module_put_and_exit in a
different #if #else already doesn't have one.

Trust it or not, apply it or not.

> Please try again.

No thanks.

cheers, Joe

> > diff --git a/include/linux/module.h b/include/linux/module.h
[]
> > @@ -454,7 +454,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> >  
> >  extern void __module_put_and_exit(struct module *mod, long code)
> >  	__attribute__((noreturn));
> > -#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
> > +#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
> >  
> >  #ifdef CONFIG_MODULE_UNLOAD
> >  unsigned long module_refcount(struct module *mod);

$ git grep -w module_put_and_exit
crypto/algboss.c:       module_put_and_exit(0);
crypto/algboss.c:       module_put_and_exit(0);
fs/cifs/connect.c:      module_put_and_exit(0);
fs/nfs/nfs4state.c:     module_put_and_exit(0);
fs/nfsd/nfssvc.c:       module_put_and_exit(0);
include/linux/module.h:#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
include/linux/module.h:#define module_put_and_exit(code) do_exit(code)
net/bluetooth/bnep/core.c:      module_put_and_exit(0);
net/bluetooth/cmtp/core.c:      module_put_and_exit(0);
net/bluetooth/hidp/core.c:      module_put_and_exit(0);


