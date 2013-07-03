Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3GCM7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:59:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab3GCM7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:59:12 -0400
Date: Wed, 3 Jul 2013 14:59:09 +0200
From: Michal Marek <mmarek@suse.cz>
To: Robert Richter <rric@kernel.org>
Cc: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Makefile: Fix install error with make -j option
Message-ID: <20130703125909.GA30955@sepie.suse.cz>
References: <1367499037-8350-1-git-send-email-rric@kernel.org>
 <20130612101347.GP3886@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612101347.GP3886@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 12:13:47PM +0200, Robert Richter wrote:
> Michal,
> 
> please apply this fix, ideally for v3.10 if possible.

I applied it to kbuild.git#kbuild now, with Cc:
<stable@vger.kernel.org>.

Michal
> 
> Thanks,
> 
> -Robert
> 
> 
> On 02.05.13 08:50:37, Robert Richter wrote:
> > From: Robert Richter <robert.richter@calxeda.com>
> > 
> > Make modules_install fails with -j option:
> > 
> >    DEPMOD
> >  Usage: .../.source/linux/scripts/depmod.sh /sbin/depmod <kernelrelease>
> >  make[1]: *** [_modinst_post] Error 1
> > 
> > Adding kernelrelease dependency to fix this.
> > 
> > Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> > ---
> >  Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 46263d8..0205e79 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -979,7 +979,7 @@ _modinst_:
> >  # boot a modules.dep even before / is mounted read-write.  However the
> >  # boot script depmod is the master version.
> >  PHONY += _modinst_post
> > -_modinst_post: _modinst_
> > +_modinst_post: include/config/kernel.release _modinst_
> >  	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst
> >  	$(call cmd,depmod)
> >  
> > -- 
> > 1.8.1.1
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
