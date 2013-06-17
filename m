Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3FQX2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:28:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:32152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3FQX2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:28:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="318511963"
Message-ID: <1371511724.22538.1.camel@rzhang1-mobl4>
Subject: Re: [PATCH -next v3] thermal:  fix x86_pkg_temp_thermal.c build and
 Kconfig
From: Zhang Rui <rui.zhang@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 18 Jun 2013 07:28:44 +0800
In-Reply-To: <20130617194524.GD8197@pd.tnic>
References: <20130617185106.5950ffbf4b96acd9b2b2c834@canb.auug.org.au>
	 <51BF4159.1000004@infradead.org> <51BF46C3.3090900@linux.intel.com>
	 <51BF4DA2.40601@infradead.org> <51BF50E3.9000806@linux.intel.com>
	 <51BF5174.805@infradead.org> <20130617181702.GA7217@pd.tnic>
	 <51BF6315.9020501@infradead.org> <20130617194524.GD8197@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 21:45 +0200, Borislav Petkov wrote:
> On Mon, Jun 17, 2013 at 12:27:17PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > Fix build error in x86_pkg_temp_thermal.c.  It requires that
> > X86_MCE & X86_THERMAL_VECTOR be enabled, so depend on the latter symbol,
> > since it depends on X86_MCE (indirectly).
> > 
> > Also, X86_PKG_TEMP_THERMAL is already inside an "if THERMAL" block,
> > so remove that duplicated dependency.
> > 
> > ERROR: "platform_thermal_package_rate_control" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!
> > ERROR: "platform_thermal_package_notify" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > ---
> >  drivers/thermal/Kconfig |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > --- linux-next-20130617.orig/drivers/thermal/Kconfig
> > +++ linux-next-20130617/drivers/thermal/Kconfig
> > @@ -171,8 +171,7 @@ config INTEL_POWERCLAMP
> >  
> >  config X86_PKG_TEMP_THERMAL
> >  	tristate "X86 package temperature thermal driver"
> > -	depends on THERMAL
> > -	depends on X86
> > +	depends on X86_THERMAL_VECTOR
> >  	select THERMAL_GOV_USER_SPACE
> >  	default m
> >  	help
> 
> Acked-by: Borislav Petkov <bp@suse.de>
> 
applied to thermal -next.

thanks,
rui

