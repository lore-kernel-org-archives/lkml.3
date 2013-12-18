Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3LRPQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:16:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:35813 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3LRPP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:15:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="83525056"
Date: Wed, 18 Dec 2013 15:15:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 08/12] xen/pvh: MMU changes for PVH
In-Reply-To: <20131218151015.GE4934@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1312181514510.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-9-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181442050.8667@kaball.uk.xensource.com> <20131218151015.GE4934@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > @@ -1834,6 +1845,9 @@ static void convert_pfn_mfn(void *v)
> > >  	pte_t *pte = v;
> > >  	int i;
> > >  
> > > +	if (xen_feature(XENFEAT_auto_translated_physmap))
> > > +		return;
> > > +
> > >  	/* All levels are converted the same way, so just treat them
> > >  	   as ptes. */
> > >  	for (i = 0; i < PTRS_PER_PTE; i++)
> > 
> > This is getting pretty bad.
> > Can we find a way to refactor xen_setup_kernel_pagetable so that we
> > don't need all this? Maybe we need a new function?
> 
> Is it that bad? Doing a copy of xen_setup_kernel_pagetable just
> for PVH strikes me as error prone. Having the checks in the
> functions that xen_setup_kernel_pagetable is much easier and
> nicer I think.
> 
> Maybe if we did a big 'if (xen_feature(XEN..)' inside of
> xen_setup_kernel_pagetable that would be easier?

Yes, that should make things clearer.
