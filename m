Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaGTVac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:30:32 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:43988 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaGTVaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:30:30 -0400
Date: Sun, 20 Jul 2014 23:30:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: =?iso-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH] kbuild: add support to generate LLVM bitcode files
Message-ID: <20140720213025.GA5103@ravnborg.org>
References: <1405733677-16650-1-git-send-email-viniciustinti@gmail.com>
 <20140720100239.GA3496@ravnborg.org>
 <20140720210458.GA5019@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720210458.GA5019@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 11:04:58PM +0200, Sam Ravnborg wrote:
> > >  
> > > +ifeq ($(COMPILER),clang)
> > > +quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
> > > +cmd_cc_ll_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -emit-llvm -S -o $@ $<
> > 
> > Can we drop the test for COMPILER here too?
> > Do -fverbose-asm make sense when generating .ll files?
> > It looks like a leftover from what you copied.
> 
> Also  $(DISABLE_LTO) looks like a left-over.
> It was added to avoid LTO when generating asm-offstes.s which
> the original rule is also used for.
> So this should be skipped too.
Third thing.
In some places we indent the assignmnet like this:
quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
      cmd_cc_ll_c = $(CC) $(c_flags) ....

This makes it more obvious that the "cmd_cc_ll_c" is actually the same.
Makefile.build does not do this much but please do for these targets.

	Sam
