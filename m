Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3GHTfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:35:13 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:63055 "EHLO
	smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:35:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,1021,1363132800"; 
   d="scan'208";a="580294938"
Date: Mon, 8 Jul 2013 12:34:59 -0700
From: Matt Wilson <msw@amazon.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        <jeremy@goop.org>, <xen-devel@lists.xensource.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
Message-ID: <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20130708192854.GF4927@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130708192854.GF4927@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:28:54PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 08, 2013 at 08:28:24AM +0200, Michael Opdenacker wrote:
> > This patch proposes to remove the XEN_PRIVILEGED_GUEST kernel
> > configuration parameter defined in arch/x86/xen/Kconfig, but used
> > nowhere in the makefiles and source code.
> > 
> > This dummy parameter was added 3 years back, and it may
> > make sense to remove it now, as the reasons to use it were not
> > very clear.
> > 
> > Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> 
> Can't remove it. It is used by grub2.

For reference, here's a related Debian bug report:
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=633127

Summary: grub2 scripts parse /boot/config-$(uname -r)

--msw

> > ---
> >  arch/x86/xen/Kconfig | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> > index 1a3c765..b6401dc 100644
> > --- a/arch/x86/xen/Kconfig
> > +++ b/arch/x86/xen/Kconfig
> > @@ -19,11 +19,6 @@ config XEN_DOM0
> >  	depends on XEN && PCI_XEN && SWIOTLB_XEN
> >  	depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI
> >  
> > -# Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
> > -# name in tools.
> > -config XEN_PRIVILEGED_GUEST
> > -	def_bool XEN_DOM0
> > -
> >  config XEN_PVHVM
> >  	def_bool y
> >  	depends on XEN && PCI && X86_LOCAL_APIC
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
