Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3KKNEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:04:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36985 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab3KKNDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:03:53 -0500
X-IronPort-AV: E=Sophos;i="4.93,677,1378857600"; 
   d="scan'208";a="73121585"
Message-ID: <1384175027.19117.15.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] xen/arm: pfn_to_mfn and mfn_to_pfn return the argument
 if nothing is in the p2m
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>
Date: Mon, 11 Nov 2013 13:03:47 +0000
In-Reply-To: <1384174231-27176-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1384174231-27176-1-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 12:50 +0000, Stefano Stabellini wrote:
> Some common Xen drivers, like balloon.c, call pfn_to_mfn and mfn_to_pfn
> even for autotranslate guests, expecting the argument back.
> The following commit broke these drivers by changing the behavior of
> pfn_to_mfn and mfn_to_pfn:
> 
> commit 4a19138c6505e224d9f4cc2fe9ada9188d7100ea
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Thu Oct 17 16:22:27 2013 +0000
> 
>     arm/xen,arm64/xen: introduce p2m
> 
> They now return INVALID_P2M_ENTRY if Linux doesn't actually know what is
> the mfn backing a pfn or what is the pfn corresponding to an mfn.
> Fix the regression by switching to the old behavior.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

I tripped over this on Friday and my local hack was identical, hence
also:

Tested-by: Ian Campbell <ian.campbell@citrix.com>

Ian.

