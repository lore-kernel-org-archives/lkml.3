Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3COSD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:03:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36395 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3COSD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:03:28 -0400
Date: Fri, 15 Mar 2013 17:58:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Turn off -Wmaybe-uninitialized when building with -Os
Message-ID: <20130315175808.GT4977@n2100.arm.linux.org.uk>
References: <7534695.eTHcH0enMV@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7534695.eTHcH0enMV@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:01:35PM +0100, Arnd Bergmann wrote:
> gcc-4.7 and higher add a lot of false positive warnings about
> potential uses of uninitialized warnings, but only when optimizing
> for size (-Os). This is the default when building allyesconfig,
> which turns on CONFIG_CC_OPTIMIZE_FOR_SIZE.
> 
> In order to avoid getting a lot of patches that initialize such
> variables and accidentally hide real errors along the way, let's
> just turn off this warning on the respective gcc versions
> when building with size optimizations. The -Wmaybe-uninitialized
> option was introduced in the same gcc version (4.7) that is now
> causing the false positives, so there is no effect on older compilers.
> 
> A side effect is that when building with CONFIG_CC_OPTIMIZE_FOR_SIZE,
> we might now see /fewer/ warnings about possibly uninitialized
> warnings than with -O2, but that is still much better than seeing
> warnings known to be bogus.

What about truely uninitialized uses of variables?  Will this hide
their warning too?
