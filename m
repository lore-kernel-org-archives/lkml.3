Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3LQTPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:15:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab3LQTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:15:47 -0500
Message-ID: <1387307715.1979.169.camel@deneb.redhat.com>
Subject: Re: [PATCH 4/4] arm64: add early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Tue, 17 Dec 2013 14:15:15 -0500
In-Reply-To: <20131205162800.GB1495@darko.cambridge.arm.com>
References: <1385606679-30446-1-git-send-email-msalter@redhat.com>
	 <1385606679-30446-5-git-send-email-msalter@redhat.com>
	 <20131205162800.GB1495@darko.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 16:28 +0000, Catalin Marinas wrote:
> > +#define FIXMAP_PAGE_NORMAL __pgprot(PROT_NORMAL | PTE_PXN | PTE_UXN)
> 
> I'll push a fix to change PROT_DEFAULT to (pgprot_default | PTE_DIRTY).
> 

This doesn't help early_ioremap because pgprot_default gets set up in
init_mem_pgprot() which is called from paging_init(). The early_ioremaps
happen before paging_init(). Would it be okay to make init_mem_pgprot()
non-static and call it from setup_arch() before early_ioremap_init()?

--Mark


