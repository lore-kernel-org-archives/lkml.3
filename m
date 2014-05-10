Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaEJKQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:16:13 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:29241 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbaEJKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:16:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIVADX8bVNXQCSg/2dsb2JhbABZgwaDPakhBQGaFQICAYEWF3SCJQEBBAE6HCMFCwgDDgouOR4GE4g5DAHRNReFVoh8B4RAAQOPJYoiAYsEiAODODs
Date: Sat, 10 May 2014 12:16:06 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] KERNEL: add __attribute__  in c file
Message-Id: <20140510121606.4270642bc3119f3e5a08b300@skynet.be>
In-Reply-To: <20140507152557.7bf8998f900c5f2054295e68@linux-foundation.org>
References: <20140507223339.3dccf63d066edbcac207e6f3@skynet.be>
	<20140507152557.7bf8998f900c5f2054295e68@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 15:25:57 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 7 May 2014 22:33:39 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > This patch fixes a sparse warning about noreturn attribute only
> > featuring in module.h
> > 
> > kernel/module.c:212:6: error: symbol '__module_put_and_exit' redeclared with
> > different type (originally declared at include/linux/module.h:449)-
> > different modifiers
> > 
> > ...
> >
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -446,8 +446,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> >  					     struct module *, unsigned long),
> >  				   void *data);
> >  
> > -extern void __module_put_and_exit(struct module *mod, long code)
> > -	__attribute__((noreturn));
> > +extern void __attribute__((noreturn)) __module_put_and_exit(struct module *mod,
> > +							    long code);
> >  #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
> >  
> >  #ifdef CONFIG_MODULE_UNLOAD
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 079c461..7d78872 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -209,7 +209,8 @@ static inline void add_taint_module(struct module *mod, unsigned flag,
> >   * A thread that wants to hold a reference to a module only while it
> >   * is running can call this to safely exit.  nfsd and lockd use this.
> >   */
> > -void __module_put_and_exit(struct module *mod, long code)
> > +void __attribute__((noreturn)) __module_put_and_exit(struct module *mod,
> > +						     long code)
> >  {
> 
> Can we use __noreturn here?
Well it works(compilation/no more sparse warning) but after looking at some documentation, it looks more like some sparse false positive.

Fabian
