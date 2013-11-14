Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3KNIdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:33:13 -0500
Received: from mail.abilis.ch ([195.70.19.74]:13814 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3KNIdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:33:11 -0500
Date: Thu, 14 Nov 2013 09:32:48 +0100
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: Uncompressed kernel doesn't build on x86_64
Message-ID: <20131114083247.GB9687@ab42.lan>
References: <20131113113418.167b8ffd@IRBT4585>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113113418.167b8ffd@IRBT4585>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 11:34:18AM -0500, Pavel Roskin wrote:
> Hi Christian,
> 
> Your recent patch enables uncompressed kernels, but selecting that
> option (CONFIG_KERNEL_UNCOMPRESSED) fails on x86_86:
> [...]
> arch/x86/boot/compressed/Makefile has no provision for uncompressed
> files.  There is no definition for suffix-$(CONFIG_KERNEL_UNCOMPRESSED)
> so $(suffix-y) evaluates to an empty string and there is no rule to
> make vmlinuz.bin.$(suffix-y)
> 
> I think the patch should be either reverted or fixed as soon as
> possible.

This is an interesting observation, thanks. Although this patch is
rather intended for embedded architectures than x86, it highlights
potential issues with self-decompressing images of all sorts. I have no
way of testing all architectures and so I'm sending two patches in the
follow-up:
1. A conservative version of the original patch which requires
   architectures to explicitly enable uncompresed kernel images if they
   support compression as well and falls back to previous behaviour if
   nothing is specified. I have copied Vineet Gupta (maintainer of the
   ARC platform) since I enabled GZIP and uncompressed kernels for ARC
   by default.
2. A patch to enable uncompressed x86 kernels. As stated above, I don't
   think this makes a lot of sense in itself but it might serve as an
   example for people working on other platforms with self-extracting
   kernels and the nozip not-decompression algorithm might be useful on
   those platforms as well. I only had a single x86-64 machine available
   to test this, however, so some more testing might be required.

> Any suggestions for uncompressed suffix?  I'd go with "copy".  Then the
> "compression" could be a symlink.  Alternatively, the "." could be
> included in other suffixes, the uncompressed suffix would be empty and
> the compression would be an empty statement.

I followed H. Peter's suggestion and chose option 2 in patch 2.

Greetings,
  Christian
