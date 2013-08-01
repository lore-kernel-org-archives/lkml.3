Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3HAMTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:19:50 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8440 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab3HAMTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:19:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="38767123"
Message-ID: <51FA5262.6090604@citrix.com>
Date: Thu, 1 Aug 2013 13:19:46 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v2 RFC 7/8] swiotlb-xen: support autotranslate guests
References: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com> <1375300452-12545-7-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1375300452-12545-7-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/13 20:54, Stefano Stabellini wrote:
> Support autotranslate guests in swiotlb-xen by keeping track of the
> phys-to-bus and bus-to-phys mappings of the swiotlb buffer
> (xen_io_tlb_start-xen_io_tlb_end).
> 
> Use a simple direct access on a pre-allocated array for phys-to-bus
> queries. Use a red-black tree for bus-to-phys queries.

It would be nice if the dma_map_page() etc. returned a unique handle in
addition to the dma_addr_t so the lookup on unmap could be cheaper, but
in the absence of this.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
