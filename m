Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaJWVtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:49:47 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:53348 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaJWVto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:49:44 -0400
Date: Thu, 23 Oct 2014 23:47:25 +0200
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        mingo@kernel.org, sam@ravnborg.org, namhyung@kernel.org
Subject: Re: [PATCH 01/15] kbuild: add support of custom paths for
 "auto.conf*" files
Message-ID: <20141023214725.GB24223@marx-slim>
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
 <1411422796-27049-2-git-send-email-alexis.berlemont@gmail.com>
 <54216F39.9030902@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54216F39.9030902@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek wrote:
> On 2014-09-22 23:53, Alexis Berlemont wrote:
> > In the scripts/Makefile.build, use KCONFIG_AUTOCONFIG to include a
> > custom path for the "auto.conf" file.
> > 
> > The "*conf" programs were modified so as to work with the environment
> > variable KCONFIG_AUTOCONFIG.
> > ---
> >  scripts/Makefile.build     |  3 ++-
> >  scripts/kconfig/confdata.c | 27 ++++++++++++++++++++++++++-
> >  scripts/kconfig/lkc.h      |  1 +
> >  3 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index bf3e677..ef60769 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -31,7 +31,8 @@ subdir-asflags-y :=
> >  subdir-ccflags-y :=
> >  
> >  # Read auto.conf if it exists, otherwise ignore
> > --include include/config/auto.conf
> > +kconfig-autoconfig := $(if $(KCONFIG_AUTOCONFIG),$(KCONFIG_AUTOCONFIG),include/config/auto.conf)
> > +-include $(kconfig-autoconfig)
> >  
> >  include scripts/Kbuild.include
> >  
> > diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> > index f88d90f..d4d8920 100644
> > --- a/scripts/kconfig/confdata.c
> > +++ b/scripts/kconfig/confdata.c
> > @@ -75,6 +75,27 @@ const char *conf_get_autoconfig_name(void)
> >  	return name ? name : "include/config/auto.conf";
> >  }
> >  
> > +#define PATH_MAXLENGTH 4096
> > +const char *conf_get_autoconfigdep_name(void)
> > +{
> > +	static char res_value[PATH_MAXLENGTH];
> > +
> > +	char *name = getenv("KCONFIG_AUTOCONFIG");
> > +
> > +	if (name == NULL)
> > +		name = "include/config/auto.conf.cmd";
> 
> This will result in "include/config/auto.conf.cmd.cmd". Better simplify
> it to name = conf_get_autoconfig_name().
> 

Sorry for such a terrible mistake. I broke everything just to make
kconfig work for perf...

> 
> > +	if (strlen(name) > PATH_MAXLENGTH - 5)
> > +		name = NULL;
> > +	else {
> > +		res_value[0] = 0;
> 
> This assignment is superfluous.

OK.

> 
> 
> > +		strncpy(res_value, name, PATH_MAXLENGTH);
> > +		strcat(res_value, ".cmd");
> > +		name = res_value;
> 
> Michal
> 

Alexis
