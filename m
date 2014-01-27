Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaA0QoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:44:13 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24057 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753810AbaA0QoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:44:12 -0500
Date: Mon, 27 Jan 2014 16:43:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jungseung Lee <js07.lee@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Q] L1_CACHE_BYTES on flush_pfn_alias function.
Message-ID: <20140127164337.GB8358@arm.com>
References: <00d501cf136a$24ec49c0$6ec4dd40$@samsung.com>
 <20140124154321.GI19052@arm.com>
 <003c01cf1a55$623979f0$26ac6dd0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003c01cf1a55$623979f0$26ac6dd0$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please do not top-post.

On Sun, Jan 26, 2014 at 05:13:43AM +0000, Jungseung Lee wrote:
> Not to flush some more bytes. In the scenario, they can *omit* to flush last 32 bytes.
> 
> L1_CACHE_BYTES = 64 (ARM v7, CA9)
> 
> asm(    "mcrr   p15, 0, %1, %0, c14\n"
>     "   mcr p15, 0, %2, c7, c10, 4"
>         :
>         : "r" (to), "r" (to + PAGE_SIZE - L1_CACHE_BYTES), "r" (zero)
>         : "cc");

Ah, I got it now. I think this should be (to + PAGE_SIZE - 1). My
reading of the ARM ARM is that the bottom bits of the address are
ignored by mcrr.

-- 
Catalin
