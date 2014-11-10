Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaKJQLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:11:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39972 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaKJQLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:11:08 -0500
Date: Mon, 10 Nov 2014 17:11:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] x86: Drop redundant memory-block sizing code
Message-ID: <20141110161105.GF4359@pd.tnic>
References: <ojh5M-xh-17@gated-at.bofh.it>
 <1415249414-20888-1-git-send-email-daniel@numascale.com>
 <20141106094007.GA4849@pd.tnic>
 <545B4E84.7050707@numascale.com>
 <20141106104034.GB4849@pd.tnic>
 <545B5735.8000401@numascale.com>
 <20141106115636.GA4318@pd.tnic>
 <54607F54.2050707@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54607F54.2050707@numascale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 05:03:16PM +0800, Daniel J Blueman wrote:
> Yes, totalram_pages doesn't count the MMIO hole, whereas max_pfn does.
> 
> I've made NumaConnect firmware changes that will guarantee max_pfn is always
> aligned to at least 2GB, so bdee237c0343a5d1a6cf72c7ea68e88338b26e08 "x86:
> mm: Use 2GB memory block size on large-memory x86-64 systems" can be dropped
> and Yinghai's approach will give 2GB memory blocks on our systems.

What about the rest of the systems? I.e., the !numascale ones. This is
generic code which needs to support all, not only your flavour.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
