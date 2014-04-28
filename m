Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbaD1Nk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:40:58 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:47189 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaD1Nkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:40:52 -0400
Date: Mon, 28 Apr 2014 09:40:47 -0400
From: Matt Porter <mporter@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: l2c: prima2: only call l2x0_of_init() on matching
 nodes
Message-ID: <20140428134047.GA7719@beef>
References: <1398644860-22973-1-git-send-email-mporter@linaro.org>
 <20140428091532.GG26756@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428091532.GG26756@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:15:33AM +0100, Russell King wrote:
> On Sun, Apr 27, 2014 at 08:27:40PM -0400, Matt Porter wrote:
> > l2x0_of_init() is executed unconditionally within the sirfsoc_l2x0_init()
> > early initcall. In a multi v7 kernel this causes bcm281xx and bcm21664
> > platform to fail boot since they have their own pre l2x0 init sequence
> > that is required. Fix this by checking that a matching OF ID is present
> > before calling l2x0_of_init().
> > 
> > Reported-by: Kevin Hilman <khilman@linaro.org>
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > ---
> > Applies against next-20140424 to fix the issue introduced in
> > 50655e6 ARM: l2c: prima2: remove cache size override
> 
> Err, this only "fixes" it because it effectively disables the L2 cache
> _entirely_ - in the above commit, I kill your private compatible strings.
>
> This doesn't make sense.  If the cache is already enabled, then the L2C
> code won't try to enable it again.

Ok, please suggest an alternative. You merged this commit..it looks like
it had no ack from the platform maintainer..and I don't have hardware.
The commit is wrong, we can't have every platform executing sirfsoc's
l2x0_of_init() call/parameters by having this stuff in an early initcall
like that.

It would be pretty straightforward to add those private compatibles
back so the approach works. If not, we need to move this to
.init_machine where it's guaranteed to only run on sirfsoc.

-Matt
