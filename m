Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010Ab3DHLFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:05:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760137Ab3DHLFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:05:34 -0400
Date: Mon, 8 Apr 2013 13:05:32 +0200
From: Michal Marek <mmarek@suse.cz>
To: Bin Wang <wbin00@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/package/Makefile: compare objtree with
 srctree instead of test KBUILD_OUTPUT
Message-ID: <20130408110532.GA3291@sepie.suse.cz>
References: <1361761524-9495-1-git-send-email-wbin00@gmail.com>
 <CAD_32VUREUgiBt2ScK31ig-p8282g7VZta+Q6Fq0pkEaDGxm+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD_32VUREUgiBt2ScK31ig-p8282g7VZta+Q6Fq0pkEaDGxm+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 09:30:32AM +0800, Bin Wang wrote:
> Hi, Michal
> 
> Is there any comments on this?

Sorry, I missed this one. I applied it to kbuild.git#misc now.

Michal
> 
> 2013/2/25 Bin Wang <wbin00@gmail.com>:
> > KBUILD_OUTPUT is always empty here, so it is useless to test it. But
> > while use O=.., objtree and srctree will be different. I compare them
> > instead.
> >
> > Signed-off-by: Bin Wang <wbin00@gmail.com>
> > ---
> >  scripts/package/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> > index 87bf080..d7b3285 100644
> > --- a/scripts/package/Makefile
> > +++ b/scripts/package/Makefile
> > @@ -36,7 +36,7 @@ $(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
> >         $(CONFIG_SHELL) $(MKSPEC) > $@
> >
> >  rpm-pkg rpm: $(objtree)/kernel.spec FORCE
> > -       @if test -n "$(KBUILD_OUTPUT)"; then \
> > +       @if test "$(objtree)" != "$(srctree)"; then \
> >                 echo "Building source + binary RPM is not possible outside the"; \
> >                 echo "kernel source tree. Don't set KBUILD_OUTPUT, or use the"; \
> >                 echo "binrpm-pkg target instead."; \
> > --
> > 1.8.1.4
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
