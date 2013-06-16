Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3FPEbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:31:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:48695 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3FPEbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:31:45 -0400
Message-ID: <1371357080.21896.115.camel@pasglop>
Subject: Re: [PATCH 2/4] powerpc: Prepare to support kernel handling of
 IOMMU map/unmap
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Sun, 16 Jun 2013 14:31:20 +1000
In-Reply-To: <1371356818.21896.114.camel@pasglop>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-3-git-send-email-aik@ozlabs.ru>
	 <1371356818.21896.114.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-16 at 14:26 +1000, Benjamin Herrenschmidt wrote:
> > +int realmode_get_page(struct page *page)
> > +{
> > +     if (PageCompound(page))
> > +             return -EAGAIN;
> > +
> > +     get_page(page);
> > +
> > +     return 0;
> > +}

Shouldn't it be get_page_unless_zero ?

Cheers,
Ben.

