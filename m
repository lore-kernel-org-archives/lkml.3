Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaAKQNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:13:51 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34248 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751241AbaAKQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:13:49 -0500
Date: Sat, 11 Jan 2014 16:13:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH REPOST] ARM: Fix regression in IXP4xx network drivers
	DMA masks.
Message-ID: <20140111161342.GM15937@n2100.arm.linux.org.uk>
References: <m338l6vldf.fsf@t19.piap.pl> <m3d2k4x5vo.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3d2k4x5vo.fsf@t19.piap.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 08:33:15PM +0100, Krzysztof Hałasa wrote:
> Russell et al.,
> 
> anything wrong with this fix?

Well, I don't understand why moving this code around fixes a problem.
After all, if PCI is enabled, then presumably common-pci.c will always
be built and run - it has to be for the PCI bus to be probed.

Oh, are you trying to use the platform notify callback to set the
DMA mask on statically defined platform devices?  No, don't do that,
initialise it in the declarations instead.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
