Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3FFJDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:03:44 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:10654 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab3FFJDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:03:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,814,1363132800"; 
   d="scan'208";a="5384016"
Message-ID: <1370509419.24512.224.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v4 5/6] arm64/xen: introduce CONFIG_XEN on
 ARM64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-arm-kernel@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <catalin.marinas@arm.com>, <konrad.wilk@oracle.com>,
        <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>
Date: Thu, 6 Jun 2013 10:03:39 +0100
In-Reply-To: <1370451727-26826-5-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1306051605030.4589@kaball.uk.xensource.com>
	 <1370451727-26826-5-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 18:02 +0100, Stefano Stabellini wrote:
> Changes in v4:
> - build the entire arch/arm/xen directory under arch/arm64, ifdef
> hypercall.S appropriately.

This is probably the best (or equal first) of a bunch of bad options :-/

> + * The Xen hypercall calling convention is very similar to the ARM/ARM64
> + * procedure calling convention: the first paramter is passed in r0/x0,

"parameter"

> + * the second in r1/x1, the third in r2/x2 and the fourth in r3/x3.
> + * Considering that Xen hypercalls have 5 arguments at most, the fifth
> + * paramter is always passed in r4/x4, differently from the ARM
> + * procedure calling convention of using the stack for that case.

and "parameter" again.

Strictly speaking the fifth argument handling only differs from the
32-bit PCS, not the 64-bit one. Splitting hairs a bit there.

If you fix the typo and clarify the fifth argument or not as you wish:

        Acked-by: Ian Campbell <ian.campbell@citrix.com>

Ian.


