Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab3BTLR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:17:57 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:23595 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902Ab3BTLRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:17:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355097600"; 
   d="scan'208";a="1647848"
Message-ID: <1361359073.23294.6.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH] xen: introduce xen_remap, use it instead of ioremap
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 20 Feb 2013 11:17:53 +0000
In-Reply-To: <alpine.DEB.2.02.1302191332340.4654@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1302191332340.4654@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 13:59 +0000, Stefano Stabellini wrote:
> ioremap can't be used to map ring pages on ARM because it uses device
> memory caching attributes (MT_DEVICE*).
> 
> Introduce a Xen specific abstraction to map ring pages, called
> xen_remap, that is defined as ioremap on x86 (no behavioral changes).
> On ARM it explicitly calls __arm_ioremap with the right caching
> attributes: MT_MEMORY.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

If you were respinning for any reason I might suggest
s/xen_remap/xen_map_shared/ or something of that nature.

Ian.

