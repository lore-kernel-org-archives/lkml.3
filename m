Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767AbaLKXt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:49:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965300AbaLKXty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:49:54 -0500
Date: Fri, 12 Dec 2014 01:49:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH RFC 3/5] pci: add pci_iomap_range
Message-ID: <20141211234936.GB9439@redhat.com>
References: <1418326570-9541-1-git-send-email-mst@redhat.com>
 <1418326570-9541-4-git-send-email-mst@redhat.com>
 <11102634.nzYXXfUH5X@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11102634.nzYXXfUH5X@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:27:54PM +0100, Arnd Bergmann wrote:
> On Thursday 11 December 2014 21:37:34 Michael S. Tsirkin wrote:
> >         if (flags & IORESOURCE_MEM) {
> > -               if (flags & IORESOURCE_CACHEABLE)
> > +               if (!force_nocache && (flags & IORESOURCE_CACHEABLE))
> >                         return ioremap(start, len);
> >                 return ioremap_nocache(start, len);
> >         }
> > 
> 
> ioremap is the same as ioremap_nocache, so this doesn't really make any
> sense. IORESOURCE_CACHEABLE is practically only set for ROM bars, which
> we rarely map.
> 
> 	Arnd

Hmm I think you are right.
It's an old patch - I think at one point in time we did set it when we
now set IORESOURCE_PREFETCH.
I'll drop this parameter.

-- 
MST
