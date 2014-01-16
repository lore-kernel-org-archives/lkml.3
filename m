Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaAPAfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:35:53 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38280 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750900AbaAPAfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:35:50 -0500
Date: Thu, 16 Jan 2014 00:35:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 4/6] arm: add early_ioremap support
Message-ID: <20140116003542.GS15937@n2100.arm.linux.org.uk>
References: <1389325833-16535-1-git-send-email-msalter@redhat.com> <1389325833-16535-5-git-send-email-msalter@redhat.com> <52D72883.3020500@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D72883.3020500@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 04:32:03PM -0800, Laura Abbott wrote:
> Neither x86 nor arm64 get rid of existing mapping in paging_init. Is  
> there a reason this needs to be here for arm? Are there concerns about  
> alias mappings?

The early mappings we setup in the assembly code are imperfect - they're
an approximation.  We map just about enough memory to get the kernel
going, and we setup a mapping for the debug stuff using a section
mapping, which may not be appropriate.

The permissions too are a just chosen to get things going, and the
subsequent replacement of the page table entries is to fix all that up.
We really don't want any old entries left behind.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
