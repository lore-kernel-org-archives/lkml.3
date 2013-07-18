Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3GRQY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:24:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37459 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab3GRQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:24:26 -0400
Date: Thu, 18 Jul 2013 17:23:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Julien Grall <julien.grall@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Patch Tracking <patches@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
	debug is disabled
Message-ID: <20130718162344.GZ24642@n2100.arm.linux.org.uk>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com> <CAPnVf8yH7PBOSSC57qJv+pWmsinRUxGr81QUPH9GoOkKw2oo3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPnVf8yH7PBOSSC57qJv+pWmsinRUxGr81QUPH9GoOkKw2oo3Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 05:15:21PM +0100, Julien Grall wrote:
> On 17 July 2013 14:25, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> > On Mon, 15 Jul 2013, Julien Grall wrote:
> >> Even if uncompress debug is disabled, some board will continue to print
> >> information during uncompress step.
> >
> > Are you talking about DEBUG_UNCOMPRESS?
> > Should I read the sentence as "even if DEBUG_UNCOMPRESS is not selected,
> > some board will continue to print information during the uncompress step"?
> 
> Yes. On the arndale, uncompress log are directly output on UART-2.
> This is annoying because  Xen doesn't expose the UART to dom0.

The DEBUG_UNCOMPRESS option is not about whether the decompressor produces
output or not.  It is about the implementation of that output.

* With non-multiplatform kernels, the output is sent to whatever functions
  are found in arch/arm/*/include/mach/uncompress.h.

* With multiplatform kernels with DEBUG_UNCOMPRESS set, the output is sent
  using the kernel's LL debug functions.  (hence it's name - it's saying
  that it uses the debug macros.)

* With multiplatform kernels without DEBUG_UNCOMPRESS set, there is no
  way to know where to send the *normal* decompressor output, so we have
  decided that in this case and this case only, it shall be silent.

The final thing to remember is... the normal output from the decompressor
is *NOT* debug output.  It's informational or error output.

Everything here is working as intended.
