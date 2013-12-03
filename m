Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3LCUMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:12:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17795 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3LCUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:12:45 -0500
Date: Tue, 3 Dec 2013 15:11:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
Message-ID: <20131203201135.GA14243@phenom.dumpdata.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
 <529DBA07.6090108@citrix.com>
 <1386068884.13256.9.camel@kazak.uk.xensource.com>
 <529DC7BA.7080506@citrix.com>
 <1386078108.13256.30.camel@kazak.uk.xensource.com>
 <529DF4A0.50103@citrix.com>
 <1386083821.13256.42.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386083821.13256.42.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If Konrad and Boris agree that breaking the kernel's ABI in this way is
> > acceptable in this specific case, I'll defer to them.
> 
> My opinion as Xen on ARM hypervisor maintainer is that this is the right
> thing to do in this case.

Heh. If somebody can guarantee me that (by testing the right variants and
mentioning this in the git commit) that this does not break x86, then
I am fine.

And by 'break x86' I mean that this combination works:
 32-bit domU on 64-bit dom0
 64-bit domU on 32-bit dom0

And perhaps also the obvious:
 64-bit domU on 64-bit dom0
 32-bit domU on 32-bit dom0

Since the xen-blkback has its own version of the structs there is no
need to change change newer and older version of it.

As long as that works I am OK sticking it in.

I think from the ARM perspective it is still in 'experimental' phase
so anything goes to make it work under ARM.

