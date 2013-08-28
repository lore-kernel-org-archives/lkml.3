Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3H1Twm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:52:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:40568 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3H1Twl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:52:41 -0400
X-IronPort-AV: E=Sophos;i="4.89,977,1367971200"; 
   d="scan'208";a="46150756"
Date: Wed, 28 Aug 2013 20:52:29 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 06/10] xen/arm,arm64: move Xen initialization
 earlier
In-Reply-To: <20130819165502.GC19712@arm.com>
Message-ID: <alpine.DEB.2.02.1308282050330.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com> <1376565054-24153-6-git-send-email-stefano.stabellini@eu.citrix.com> <20130819165502.GC19712@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013, Catalin Marinas wrote:
> On Thu, Aug 15, 2013 at 12:10:50PM +0100, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Some explanation on why and how early it needs to be moved?

It only needs to be moved before any dma requests are made.
I am not sure exactly where the right place for it would be but I was
pretty sure that right after psci_init would be early enough.
