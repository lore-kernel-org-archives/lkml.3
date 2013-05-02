Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367Ab3EBSOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:14:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22665 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760857Ab3EBSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:14:07 -0400
Date: Thu, 2 May 2013 14:13:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH, RFC 18/22] Xen: SWIOTLB is only used on x86
Message-ID: <20130502181309.GA23642@phenom.dumpdata.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
 <1367507786-505303-19-git-send-email-arnd@arndb.de>
 <alpine.DEB.2.02.1305021638100.5398@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305021638100.5398@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:38:50PM +0100, Stefano Stabellini wrote:
> On Thu, 2 May 2013, Arnd Bergmann wrote:
> > Enabling SWIOTLB_XEN on ARM results in build errors because the
> > underlying SWIOTLB is only available on X86:
> > 
> > drivers/xen/swiotlb-xen.c: In function 'is_xen_swiotlb_buffer':
> > drivers/xen/swiotlb-xen.c:105:2: error: implicit declaration of function 'mfn_to_local_pfn
> > 
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked as well. Should I pull this in or Arnd are you OK with taking
with my our Acks?

Thanks.
> 
> 
> >  drivers/xen/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> > index dd4d9cb..f03bf50 100644
> > --- a/drivers/xen/Kconfig
> > +++ b/drivers/xen/Kconfig
> > @@ -141,7 +141,7 @@ config XEN_GRANT_DEV_ALLOC
> >  
> >  config SWIOTLB_XEN
> >  	def_bool y
> > -	depends on PCI
> > +	depends on PCI && X86
> >  	select SWIOTLB
> >  
> >  config XEN_TMEM
> > -- 
> > 1.8.1.2
> > 
