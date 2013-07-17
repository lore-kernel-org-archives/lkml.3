Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3GQPMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:12:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37267 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3GQPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:12:32 -0400
Date: Wed, 17 Jul 2013 16:11:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Julien Grall <julien.grall@linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
	debug is disabled
Message-ID: <20130717151148.GM24642@n2100.arm.linux.org.uk>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 02:25:38PM +0100, Stefano Stabellini wrote:
> On Mon, 15 Jul 2013, Julien Grall wrote:
> > Even if uncompress debug is disabled, some board will continue to print
> > information during uncompress step.
> 
> Are you talking about DEBUG_UNCOMPRESS?
> Should I read the sentence as "even if DEBUG_UNCOMPRESS is not selected,
> some board will continue to print information during the uncompress step"?
> 
> Isn't this a bug in the platform specific code that should be fixed anyway?

Hang on, let's be clear what's going on here.

1. The normal output from the decompressor is *not* debugging.  By that
   I mean the "Uncompressing kernel... done" message.  That is part of
   user output.

2. In non-multiplatform environments, the decompressor will normally use
   the putc/flush functions found in arch/arm/mach-*/include/mach/uncompress.h
   to implement its output, irrespective of the DEBUG_UNCOMPRESS setting.
   (An interesting point is that DEBUG_UNCOMPRESS really should depend on
   MULTIPLATFORM so that this point is explicit - the option requires
   MULTIPLATFORM to be set.)

3. DEBUG_UNCOMPRESS allows the functions which we've implemented for LL
   debug to be re-used for decompressor output.

4. When DEBUG_UNCOMPRESS is not set in a multiplatform kernel, the
   decompressors putc() and flush() functions are stubbed out.

So, it's quite right that you get output from the decompressor even when
DEBUG_UNCOMPRESS is not set.  There's no problem with that.
