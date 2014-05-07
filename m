Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaEGHjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:39:04 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51745 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaEGHjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:39:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 2/5] DMA-API: Change dma_declare_coherent_memory() CPU address to phys_addr_t
Date: Wed, 07 May 2014 09:38 +0200
Message-ID: <6609032.iqZgu2KXQo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140506224826.17968.59068.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140506224826.17968.59068.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PBrLxdDGC0nZC9gbD/fN0K6qw4Qj5Ev1ul2tpospUKy
 rW4GPsDue1wt/HJgJO3XGKXAbK8FMUAbUKn8W6TgoVQue14RUX
 JafuIggje4E6IuC/iB+I8yAC0jGeLmurDr5hm1El1vdqXNJkkd
 HNpoNyAINg09Rhdzn4SGy0pExUEvxKm98T1rhqzrLbkh7a/Ke9
 QdqPbV4SxhDl/OI4TtFQnjrPSJrfSuVUy7XcXF3LyO5z8a1xxy
 WczBPSz1X7Nf5PUR8T3+P38Xj1NSpMBGKMkqA/BsR8rxxPda2L
 9Tvai4Uf9wn3BGjHUS1bfC2SroLXGd5e1TdyRWS++ALvnTHCbn
 8byvQnCj2vUa++bYWyzc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 16:48:26 Bjorn Helgaas wrote:
> dma_declare_coherent_memory() takes two addresses for a region of memory: a
> "bus_addr" and a "device_addr".  I think the intent is that "bus_addr" is
> the physical address a *CPU* would use to access the region, and
> "device_addr" is the bus address the *device* would use to address the
> region.
> 
> Rename "bus_addr" to "phys_addr" and change its type to phys_addr_t.
> Most callers already supply a phys_addr_t for this argument.  The others
> supply a 32-bit integer (a constant, unsigned int, or __u32) and need no
> change.
> 
> Use "unsigned long", not phys_addr_t, to hold PFNs.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
