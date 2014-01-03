Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaACPux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:50:53 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37804 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaACPuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:50:51 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89571484"
Date: Fri, 3 Jan 2014 15:50:02 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 06/18] xen/pvh: MMU changes for PVH (v2)
In-Reply-To: <52C54C82.5010802@citrix.com>
Message-ID: <alpine.DEB.2.02.1401031549520.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-7-git-send-email-konrad.wilk@oracle.com> <52C54C82.5010802@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > .. which are surprinsingly small compared to the amount for PV code.
> > 
> > PVH uses mostly native mmu ops, we leave the generic (native_*) for
> > the majority and just overwrite the baremetal with the ones we need.
> > 
> > We also optimize one - the TLB flush. The native operation would
> > needlessly IPI offline VCPUs causing extra wakeups. Using the
> > Xen one avoids that and lets the hypervisor determine which
> > VCPU needs the TLB flush.
> 
> This TLB flush optimization should be a separate patch.

Right.
Aside from this:

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
