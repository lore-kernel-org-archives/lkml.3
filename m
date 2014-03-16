Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaCPQc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:32:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9323 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbaCPQc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:32:56 -0400
X-IronPort-AV: E=Sophos;i="4.97,664,1389744000"; 
   d="scan'208";a="110495464"
Date: Sun, 16 Mar 2014 16:32:34 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Matt Wilson <msw@linux.com>,
        Anthony Liguori <aliguori@amazon.com>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <virtualization@lists.linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/grant-table: Refactor gnttab_[un]map_refs to avoid
 m2p_override
In-Reply-To: <531DF7FE.1000708@citrix.com>
Message-ID: <alpine.DEB.2.02.1403161631580.30819@kaball.uk.xensource.com>
References: <1393516530-9145-1-git-send-email-zoltan.kiss@citrix.com> <531DF7FE.1000708@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, David Vrabel wrote:
> On 27/02/14 15:55, Zoltan Kiss wrote:
> > (This is a continuation of "[PATCH v9] xen/grant-table: Avoid m2p_override
> > during mapping")
> > 
> > The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
> > for blkback and future netback patches it just cause a lock contention, as
> > those pages never go to userspace. Therefore this series does the following:
> > - the bulk of the original function (everything after the mapping hypercall)
> >   is moved to arch-dependent set/clear_foreign_p2m_mapping
> > - the "if (xen_feature(XENFEAT_auto_translated_physmap))" brach goes to ARM
> > - therefore the ARM function could be much smaller, the m2p_override stubs
> >   could be also removed
> > - on x86 the set_phys_to_machine calls were moved up to this new funcion
> >   from m2p_override functions
> > - and m2p_override functions are only called when there is a kmap_ops param
> > 
> > It also removes a stray space from arch/x86/include/asm/xen/page.h.
> 
> Applied to devel/for-linus-3.15.

The patch breaks the ARM build:

arch/arm/xen/p2m.c:152:1: error: expected identifier or '(' before '{' token
 {
 ^
arch/arm/xen/p2m.c:169:1: error: expected identifier or '(' before '{' token
 {
 ^

