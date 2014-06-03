Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbaFCROM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:14:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbaFCROL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:14:11 -0400
Date: Tue, 3 Jun 2014 13:13:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 01/13] bin2c: Move bin2c in scripts/basic
Message-ID: <20140603171327.GJ23395@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-2-git-send-email-vgoyal@redhat.com>
 <20140603160126.GB18806@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603160126.GB18806@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 06:01:26PM +0200, Borislav Petkov wrote:
> On Tue, Jun 03, 2014 at 09:06:50AM -0400, Vivek Goyal wrote:
> > Kexec wants to use bin2c and it wants to use it really early in the build
> > process. See arch/x86/purgatory/ code in later patches.
> > 
> > So move bin2c in scripts/basic so that it can be built very early and
> > be usable by arch/x86/purgatory/
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  kernel/Makefile        |  2 +-
> >  scripts/Makefile       |  1 -
> >  scripts/basic/Makefile |  1 +
> >  scripts/basic/bin2c.c  | 35 +++++++++++++++++++++++++++++++++++
> >  scripts/bin2c.c        | 36 ------------------------------------
> >  5 files changed, 37 insertions(+), 38 deletions(-)
> >  create mode 100644 scripts/basic/bin2c.c
> >  delete mode 100644 scripts/bin2c.c
> > 
> > diff --git a/kernel/Makefile b/kernel/Makefile
> > index f2a8b62..9b07bb7 100644
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -105,7 +105,7 @@ targets += config_data.gz
> >  $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
> >  	$(call if_changed,gzip)
> >  
> > -      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;")
> > +      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/basic/bin2c; echo "MAGIC_END;")
> >  targets += config_data.h
> >  $(obj)/config_data.h: $(obj)/config_data.gz FORCE
> >  	$(call filechk,ikconfiggz)
> > diff --git a/scripts/Makefile b/scripts/Makefile
> > index 1d07860..e9d56fb 100644
> > --- a/scripts/Makefile
> > +++ b/scripts/Makefile
> > @@ -13,7 +13,6 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
> >  hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
> >  hostprogs-$(CONFIG_LOGO)         += pnmtologo
> >  hostprogs-$(CONFIG_VT)           += conmakehash
> > -hostprogs-$(CONFIG_IKCONFIG)     += bin2c
> 
> You also'd need to move the "bin2c" entry from scripts/.gitignore to
> scripts/basic/.gitignore. I just noticed this by grepping around the
> sources.

Good catch. Will do in next version.

Thanks
Vivek
