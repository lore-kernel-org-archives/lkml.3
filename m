Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3FEMid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:38:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23080 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3FEMib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:38:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,806,1363132800"; 
   d="scan'208";a="29368927"
Date: Wed, 5 Jun 2013 13:38:26 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3 5/6] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
In-Reply-To: <1370435014.24512.190.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1306051334580.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>  <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com> <1370435014.24512.190.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Ian Campbell wrote:
> On Wed, 2013-06-05 at 13:15 +0100, Stefano Stabellini wrote:
> > Introduce CONFIG_XEN and the implementation of hypercall.S (that is
> > the only ARMv8 specific code in Xen support for ARM).
> > 
> > Compile enlighten.c and grant_table.c from arch/arm.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> > [....]
> > +#define HYPERCALL_SIMPLE(hypercall)		\
> > +ENTRY(HYPERVISOR_##hypercall)			\
> > +	mov x16, #__HYPERVISOR_##hypercall;	\
> > +	hvc XEN_IMM;						\
> > +	ret;								\
> 
> Not sure if this is corruption due to whitespace/email etc but it'd be
> nice to align those \'s.

They are aligned with ts=4, misaligned with ts=8 (ts is vim terminology
for "how many spaces a tab equals to") :-/

Given that according to Linux coding style tabs are 8 characters, I'll
fix the indentation.
