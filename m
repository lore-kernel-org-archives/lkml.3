Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaKRTLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:11:14 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:54159 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaKRTLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:11:12 -0500
Date: Tue, 18 Nov 2014 19:11:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 3/3] ARM: reduce size of page table directory for
 short mode
Message-ID: <20141118191104.GD4042@n2100.arm.linux.org.uk>
References: <20141118165313.9958.1242.stgit@buzz>
 <20141118165325.9958.84370.stgit@buzz>
 <20141118181412.GO28279@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118181412.GO28279@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 06:14:12PM +0000, Catalin Marinas wrote:
> Actually, with LPAE you can save a pmd and pte allocated for the vectors
> page at 0xffff0000. So you can save 8K per task here. Similarly with the
> classic MMU, you can save another 4K for the vectors page pte.

No.  For any CPU which has high vectors (approximately ARMv5 and up),
there is no "vectors page pte".  The vectors page PTE is only allocated
when we need low vectors.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
