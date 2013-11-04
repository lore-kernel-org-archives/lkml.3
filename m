Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3KDQ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:28:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:26112 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab3KDQ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:28:09 -0500
X-IronPort-AV: E=Sophos;i="4.93,633,1378857600"; 
   d="scan'208";a="70364661"
Message-ID: <1383582410.8826.116.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v3] p2m: use GNTTABOP_unmap_and_duplicate if
 available
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Roger Pau =?ISO-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
Date: Mon, 4 Nov 2013 16:26:50 +0000
In-Reply-To: <5277C6B3.1000500@citrix.com>
References: <1383579524-12465-1-git-send-email-roger.pau@citrix.com>
	 <1383580147.8826.104.camel@kazak.uk.xensource.com>
	 <5277C6B3.1000500@citrix.com>
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

On Mon, 2013-11-04 at 17:09 +0100, Roger Pau Monné wrote:
> On 04/11/13 16:49, Ian Campbell wrote:
> > On Mon, 2013-11-04 at 16:38 +0100, Roger Pau Monne wrote:
> >> The new GNTTABOP_unmap_and_duplicate operation 
> > 
> > I don't see this op in mainline Xen anywhere...
> > 
> > Was it part of Stefano's original swiotlb for ARM stuff? If so we've
> > dropped that approach for ARM and the new solution doesn't require
> > hypervisor changes so the upstreaming of this hypercall ended, so you'd
> > have to pick it up and complete that work if you want to use it.
> 
> It's not part of the ARM stuff,

oops, my mistake, sorry.

>  the patch to add that OP is here:
> 
> http://lists.xen.org/archives/html/xen-devel/2013-07/msg02825.html
> 
> I guess I will need to resend that also.

Yes, I think you want to get the hcall locked down before you add
anything to the kernel to use it...



