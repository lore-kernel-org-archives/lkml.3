Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3HAPNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:13:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1103 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab3HAPNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:13:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,795,1367971200"; 
   d="scan'208";a="38811391"
Date: Thu, 1 Aug 2013 16:13:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH RFC 5/8] xen: introduce XENMEM_get_dma_buf and
 xen_put_dma_buf
In-Reply-To: <22032fc7-81f5-4271-81b6-cd2bee277fb5@email.android.com>
Message-ID: <alpine.DEB.2.02.1308011608330.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-5-git-send-email-stefano.stabellini@eu.citrix.com> <22032fc7-81f5-4271-81b6-cd2bee277fb5@email.android.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Konrad Rzeszutek Wilk wrote:
> Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> >Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >---
> >include/xen/interface/memory.h |   62
> >++++++++++++++++++++++++++++++++++++++++
> > 1 files changed, 62 insertions(+), 0 deletions(-)
> >
> >diff --git a/include/xen/interface/memory.h
> >b/include/xen/interface/memory.h
> >index 2ecfe4f..ffd7f4e 100644
> >--- a/include/xen/interface/memory.h
> >+++ b/include/xen/interface/memory.h
> >@@ -263,4 +263,66 @@ struct xen_remove_from_physmap {
> > };
> > DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
> > 
> >+#define XENMEM_get_dma_buf             26
> >+/*
> >+ * This hypercall is similar to XENMEM_exchange: it exchanges the
> >pages
> 
> Could you elaborate why the existing hyper call won't work? 

Two reasons:

- the existing XENMEM_exchange hypercall does not copy back the mfns
into the out field for autotranslate guests;

- the existing XENMEM_exchange hypercall does not guarantee that the
hypervisor won't change the p2m mappings for the exchanged pages while
the guest is using them. Keep in mind that Xen never promises to keep
the p2m mapping stable for autotranslate guests in general.
In practice it won't happen unless you use uncommon features like memory
sharing or paging.
