Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaA1Jfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:35:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:54102 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaA1Jft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:35:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,735,1384300800"; 
   d="scan'208";a="95157608"
Message-ID: <1390901746.7753.5.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] xen/gnttab: Use phys_addr_t to describe the grant frame
 base address
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Julien Grall <julien.grall@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <stefano.stabellini@eu.citrix.com>,
        <patches@linaro.org>
Date: Tue, 28 Jan 2014 09:35:46 +0000
In-Reply-To: <1390871025-29079-1-git-send-email-julien.grall@linaro.org>
References: <1390871025-29079-1-git-send-email-julien.grall@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 01:03 +0000, Julien Grall wrote:
> On ARM, address size can be 32 bits or 64 bits (if CONFIG_ARCH_PHYS_ADDR_T_64BIT
> is enabled).
> We can't assume that the grant frame base address will always fits in an
> unsigned long. Use phys_addr_t instead of unsigned long as argument for
> gnttab_setup_auto_xlat_frames.

Strictly speaking I think it would be wrong for the tools to provide a
grant frame address which only kernels with LPAE support enabled could
use, so the issue is more theoretical than a real danger.

The patch is still correct though.

> Signed-off-by: Julien Grall <julien.grall@linaro.org>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

