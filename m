Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaIOKa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:30:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56988 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753432AbaIOKa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:30:27 -0400
Date: Mon, 15 Sep 2014 11:30:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [RFC] arm:extend the reserved mrmory for initrd to be page
	aligned
Message-ID: <20140915103013.GB12361@n2100.arm.linux.org.uk>
References: <35FD53F367049845BC99AC72306C23D103D6DB4915FC@CNBJMBX05.corpusers.net> <20140915084616.GX12361@n2100.arm.linux.org.uk> <35FD53F367049845BC99AC72306C23D103D6DB491604@CNBJMBX05.corpusers.net> <20140915093014.GZ12361@n2100.arm.linux.org.uk> <35FD53F367049845BC99AC72306C23D103D6DB491605@CNBJMBX05.corpusers.net> <20140915101632.GA12361@n2100.arm.linux.org.uk> <35FD53F367049845BC99AC72306C23D103D6DB491606@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103D6DB491606@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 06:22:12PM +0800, Wang, Yalin wrote:
> Oh, I see your meaning,
> Yeah , my initrd is a cpio image,
> And it can still work after apply this patch.

Okay, that's what I wanted to know.  However, I believe your patch to
be incorrect.  You delete the assignments to initrd_start and initrd_end
in arm_memblock_init(), which will result in non-OF platforms having
no initrd.

The reason is that OF platforms set initrd_start and initrd_size from
the OF code (drivers/of/fdt.c), but ATAG platforms only set our private
phys_* versions.

The reason I went with phys_* stuff was to permit better verification
of the addresses passed - that the addresses were indeed memory locations
before passing them through something like __va().

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
