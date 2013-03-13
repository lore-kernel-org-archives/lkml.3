Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab3CMSPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:15:43 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:20890 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab3CMSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:15:41 -0400
Date: Wed, 13 Mar 2013 19:15:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-next@vger.kernel.org
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
Message-ID: <20130313181538.GA20097@merkur.ravnborg.org>
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au> <5139AC39.90805@imgtec.com> <874ngiwije.fsf@rustcorp.com.au> <20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au> <87ppz5usts.fsf@rustcorp.com.au> <20130312233300.9d86d47bb5369923ad520a21@canb.auug.org.au> <87ehfkuq27.fsf@rustcorp.com.au> <20130313063157.GB19681@merkur.ravnborg.org> <514044FD.2040502@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514044FD.2040502@imgtec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:21:01AM +0000, James Hogan wrote:
> Hi Sam,
> 
> On 13/03/13 06:31, Sam Ravnborg wrote:
> >>  /* Some toolchains use a `_' prefix for all user symbols. */
> >> -#ifdef CONFIG_SYMBOL_PREFIX
> >> -#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> >> +#ifdef CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX
> >> +#define __VMLINUX_SYMBOL(x) _##x
> >> +#define __VMLINUX_SYMBOL_STR(x) "_" #x
> >> +#define VMLINUX_SYMBOL_PREFIX_STR "_"
> >>  #else
> >> -#define MODULE_SYMBOL_PREFIX ""
> >> +#define __VMLINUX_SYMBOL(x) x
> >> +#define __VMLINUX_SYMBOL_STR(x) #x
> >> +#define VMLINUX_SYMBOL_PREFIX_STR ""
> >>  #endif
> > 
> > We know the prefix is an underscore. No benefits from defining
> > VMLINUX_SYMBOL_PREFIX_STR.
> 
> scripts/modpost.c uses the actual prefix string though:
> 
> >	if (memcmp(symname, MODULE_SYMBOL_PREFIX,
> >		   strlen(MODULE_SYMBOL_PREFIX)) == 0) {
> >		mod->unres =
> >		  alloc_symbol(symname +
> >		               strlen(MODULE_SYMBOL_PREFIX),
> > 		               ELF_ST_BIND(sym->st_info) == STB_WEAK,
> > 		               mod->unres);
> 

Allowing ourself to know this is "_" then we could make the above code look
something like:

	if (have_symbol_prefix_underscore) {
		if (symname[0] == '_') {
			mod->unres =
			...

But I do not feel strong about this part.

It is much more important to clean up so we use the
same definition all over the kernel.

	Sam
