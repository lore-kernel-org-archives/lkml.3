Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaACNTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:19:55 -0500
Received: from smtp.citrix.com ([66.165.176.89]:58136 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaACNTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:19:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89528013"
Date: Fri, 3 Jan 2014 13:19:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Wei Liu <liuw@liuw.name>
CC: Chen Baozi <baozich@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        xen-devel <xen-devel@lists.xenproject.org>, <catalin.marinas@arm.com>,
        <msalter@redhat.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH] arm64/xen: redefine xen_remap on arm64
In-Reply-To: <CAOsiSVWe7zRL2qmExHL3D4ayYyHmzHU=PonQ+-Q625Vkji+J4A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1401031318220.8667@kaball.uk.xensource.com>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com> <CAOsiSVWe7zRL2qmExHL3D4ayYyHmzHU=PonQ+-Q625Vkji+J4A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Wei Liu wrote:
> On Mon, Dec 30, 2013 at 6:55 AM, Chen Baozi <baozich@gmail.com> wrote:
> > xen_remap used to be defined as ioremap_cached on arm64. In commit
> > c04e8e2fe, a new ioremap_cache was implemented, and ioremap_cached
> > was deleted, while xen_remap stays the same. This would lead to
> > the failure when building with CONFIG_HVC_XEN. Redefined xen_remap
> > on arm64 as ioremap_cache on arm64 to fix it.
> >
> > Signed-off-by: Chen Baozi <baozich@gmail.com>
> > ---
> >  arch/arm/include/asm/xen/page.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> > index 75579a9..b3368df 100644
> > --- a/arch/arm/include/asm/xen/page.h
> > +++ b/arch/arm/include/asm/xen/page.h
> > @@ -117,6 +117,10 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> >         return __set_phys_to_machine(pfn, mfn);
> >  }
> >
> > +#ifdef CONFIG_ARM64
> > +#define xen_remap(cookie, size) ioremap_cache((cookie), (size))
> > +#else
> >  #define xen_remap(cookie, size) ioremap_cached((cookie), (size));
> 
> Looks like there's an redundant semicolon in the original implementation.

Well spotted. We can fix this separately.
Do you want to send a patch for it?
