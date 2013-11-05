Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3KEPIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:08:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:31187 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3KEPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:08:29 -0500
X-IronPort-AV: E=Sophos;i="4.93,640,1378857600"; 
   d="scan'208";a="68176507"
Message-ID: <1383664090.13961.88.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if
 kmap_ops is not set
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Roger Pau =?ISO-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        Matt Wilson <msw@amazon.com>, <xen-devel@lists.xen.org>
Date: Tue, 5 Nov 2013 15:08:10 +0000
In-Reply-To: <5279085E.7070703@citrix.com>
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
	 <5278E64C.40200@citrix.com> <527904EC.9090402@citrix.com>
	 <20131105145607.GB25836@phenom.dumpdata.com> <5279085E.7070703@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 16:01 +0100, Roger Pau Monné wrote:
> On 05/11/13 15:56, Konrad Rzeszutek Wilk wrote:
> > On Tue, Nov 05, 2013 at 03:47:08PM +0100, Roger Pau Monné wrote:
> >> On 05/11/13 13:36, David Vrabel wrote:
> >>> On 05/11/13 11:24, Roger Pau Monne wrote:
> >>>> IMHO there's no reason to set a m2p override if the mapping is done in
> >>>> kernel space, so only set the m2p override when kmap_ops is set.
> >>>
> >>> Can you provide a more detailed reasoning about why this is safe?
> >>
> >> To tell the truth, I don't understand why we need to use the m2p
> >> override for kernel space only mappings, my understanding is that this
> >> m2p override is needed for user space mappings only (where we actually
> >> end up doing two mappings, one in kernel space and one in user space).
> >> For kernel space I don't see why we need to do anything else than
> >> setting the right p2m translation.
> > 
> > We needed the m2p when doing DMA operations. As the driver would
> > want the bus address (so p2m) and then when unmapping the DMA we
> > only get the bus address  - so we needed to do a m2p lookup.
> 
> OK, we need a m2p (that we already have in machine_to_phys_mapping),
> what I don't understand is why we need the m2p override.

The m2p is a host global table.

For a foreign page grant mapped into the current domain the m2p will
give you the foreign (owner) domain's p from the m, not the local one.

Ian.


