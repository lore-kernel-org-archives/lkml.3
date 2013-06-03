Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab3FCQ01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:26:27 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:43868 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752767Ab3FCQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:26:26 -0400
Date: Mon, 3 Jun 2013 17:25:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 5/5] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
Message-ID: <20130603162517.GC32295@arm.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
 <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370273624-26976-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 04:33:44PM +0100, Stefano Stabellini wrote:
> --- /dev/null
> +++ b/arch/arm64/xen/hypercall.S
...
> +/*
> + * The Xen hypercall calling convention is very similar to the ARM AEBI
> + * procedure calling convention: the first paramter is passed in x0, the
> + * second in x1, the third in x2 and the fourth in x3. Considering that
> + * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
> + * in rx, differently from the procedure calling convention of using the
> + * stack for that case.

You may want to use the AArch64 ABI here where parameters are passed in
x0-x7, return in x0.

BTW, I think it's missing a MAINTAINERS file update.

Otherwise, the series looks good. How do you plan to upstream this?

-- 
Catalin
