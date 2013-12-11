Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3LKQTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:19:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27170 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3LKQTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:19:05 -0500
X-IronPort-AV: E=Sophos;i="4.93,872,1378857600"; 
   d="scan'208";a="83283413"
Date: Wed, 11 Dec 2013 16:18:36 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
In-Reply-To: <20131203201135.GA14243@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1312111618120.7093@kaball.uk.xensource.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com> <529DBA07.6090108@citrix.com> <1386068884.13256.9.camel@kazak.uk.xensource.com> <529DC7BA.7080506@citrix.com> <1386078108.13256.30.camel@kazak.uk.xensource.com> <529DF4A0.50103@citrix.com>
 <1386083821.13256.42.camel@kazak.uk.xensource.com> <20131203201135.GA14243@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > If Konrad and Boris agree that breaking the kernel's ABI in this way is
> > > acceptable in this specific case, I'll defer to them.
> > 
> > My opinion as Xen on ARM hypervisor maintainer is that this is the right
> > thing to do in this case.
> 
> Heh. If somebody can guarantee me that (by testing the right variants and
> mentioning this in the git commit) that this does not break x86, then
> I am fine.
> 
> And by 'break x86' I mean that this combination works:
>  32-bit domU on 64-bit dom0
>  64-bit domU on 32-bit dom0
> 
> And perhaps also the obvious:
>  64-bit domU on 64-bit dom0
>  32-bit domU on 32-bit dom0
> 
> Since the xen-blkback has its own version of the structs there is no
> need to change change newer and older version of it.
> 
> As long as that works I am OK sticking it in.
> 
> I think from the ARM perspective it is still in 'experimental' phase
> so anything goes to make it work under ARM.


Roger, can you please test this patch on x86 as suggested by Konrad and
confirm that it doesn't break anything?
