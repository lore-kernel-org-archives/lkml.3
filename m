Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaAJLe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:34:26 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33238 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750910AbaAJLeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:34:21 -0500
Date: Fri, 10 Jan 2014 11:34:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 4/6] arm: add early_ioremap support
Message-ID: <20140110113415.GH27432@n2100.arm.linux.org.uk>
References: <1389325833-16535-1-git-send-email-msalter@redhat.com> <1389325833-16535-5-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389325833-16535-5-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 10:50:31PM -0500, Mark Salter wrote:
> +#define FIXMAP_PAGE_NORMAL (L_PTE_MT_WRITEBACK | L_PTE_YOUNG | L_PTE_PRESENT)
> +#define FIXMAP_PAGE_IO (L_PTE_MT_DEV_NONSHARED | L_PTE_YOUNG | L_PTE_PRESENT)

Doesn't this also want L_PTE_XN for at least IO mappings - maybe for the
normal too if no code is expected to be run from it.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
