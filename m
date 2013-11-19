Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3KSPkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:40:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25233 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3KSPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:40:15 -0500
Date: Tue, 19 Nov 2013 10:38:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
Cc: xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] xen: vnuma introduction for pv guest
Message-ID: <20131119153837.GA5966@phenom.dumpdata.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 03:25:48PM -0500, Elena Ufimtseva wrote:
> Xen vnuma introduction.
> 
> The patchset introduces vnuma to paravirtualized Xen guests
> runnning as domU.
> Xen subop hypercall is used to retreive vnuma topology information.
> Bases on the retreived topology from Xen, NUMA number of nodes,
> memory ranges, distance table and cpumask is being set.
> If initialization is incorrect, sets 'dummy' node and unsets
> nodemask.
> vNUMA topology is constructed by Xen toolstack. Xen patchset is
> available at https://git.gitorious.org/xenvnuma/xenvnuma.git:v3.

Yeey!

One question - I know you had questions about the
PROT_GLOBAL | ~PAGE_PRESENT being set on PTEs that are going to
be harvested for AutoNUMA balancing. 

And that the hypercall to set such PTE entry disallows the
PROT_GLOBAL (it stripts it off)? That means that when the
Linux page system kicks in (as it has ~PAGE_PRESENT) the
Linux pagehandler won't see the PROT_GLOBAL (as it has
been filtered out). Which means that the AutoNUMA code won't
kick in.

(see http://article.gmane.org/gmane.comp.emulators.xen.devel/174317)

Was that problem ever answered?
