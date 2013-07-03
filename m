Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab3GCQFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:05:06 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:42992 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3GCQFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:05:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,988,1363132800"; 
   d="scan'208";a="6347033"
Message-ID: <1372867497.27768.282.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen/arm: domain kernel: Small fixes for
 making suspendable for arm
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Jaeyong Yoo <jaeyong.yoo@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>
Date: Wed, 3 Jul 2013 17:04:57 +0100
In-Reply-To: <alpine.DEB.2.02.1307031440350.5067@kaball.uk.xensource.com>
References: <1372842988-27547-1-git-send-email-jaeyong.yoo@samsung.com>
	 <alpine.DEB.2.02.1307031440350.5067@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 16:59 +0100, Stefano Stabellini wrote:

> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 2c3bdce..77309f7 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1469,6 +1469,9 @@ config ARCH_NO_VIRT_TO_BUS
> >  config ISA_DMA_API
> >  	bool
> >  
> > +config ARCH_HIBERNATION_POSSIBLE
> > +        def_bool y
> > +
> 
> This could be an issue because if you introduce this symbol you allow
> users to compile hibernation code on all arm platforms.
> At the very least it should have "depends on XEN".
> 
[...]
> > +void save_processor_state(void)
> > +{
> > +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> > +}
> > +
> > +void restore_processor_state(void)
> > +{
> > +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> > +}
> > +
> > +int swsusp_arch_suspend(void)
> > +{
> > +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> > +	return 0;
> > +}
> > +
> > +int swsusp_arch_resume(void)
> > +{
> > +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> > +	return 0;
> > +}
> > +
> > +int pfn_is_nosave(unsigned long pfn)
> > +{
> > +	printk(KERN_ERR"%s: function not implemented\n", __func__);
> > +	return 0;
> > +}
> 
> These functions are not Xen specific, they should not be under
> arch/arm/xen.
> Maybe we could put them under arch/arm/power or drivers/xen?

Together with the spurious config symbol this suggests that perhaps the
hibernation interface is not the right one to be using for Xen on ARM.

How does this work on native ARM I wonder?

Ian.

