Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab3GWXKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:10:08 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:59391 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab3GWXKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:10:06 -0400
Date: Tue, 23 Jul 2013 18:10:01 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation/Changes: phase out Changes file that
 hasn't changed
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130723225715.GD31864@blackmetal.musicnaut.iki.fi> (from
	aaro.koskinen@iki.fi on Tue Jul 23 17:57:15 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374621001.3031.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 05:57:15 PM, Aaro Koskinen wrote:
> Hi,
> 
> On Sun, Jul 21, 2013 at 01:12:55AM -0400, Paul Gortmaker wrote:
> > Looking at the bigger picture, the need for this file has simply
> > passed.  It was trying to detail required versions of userspace
> > packages, in order to cater to hand-crafted systems.  But now the
> > majority of users get their userspace all at once from some kind
> > of distro, and we are probably a lot more serious about avoiding
> > breaking userspace than we were a dozen years ago.

You're right, there's no such thing as "embedded linux", nobody creates  
their own hand-crafted systems, or assembles cross-compiling  
environments to target hardware other than x86. That's crazy talk.

> Is there any file describing the needed tools (and minimum versions)  
> to
> _build_ the kernel? I agree that trying to describe such for the  
> run-time
> userspace does not belong to the kernel tree, but the  
> required/supported
> versions of build tools should be still maybe documented...

Documentation/changes _is_ the file that describes the kernel's  
build-time prerequisites. It hasn't changed in a while because we've  
been maintaining backwards compatability, especially for several  
non-x86 targets where it's fiddly to get newer toolchain versions.

(Personally I use the last GPLv2 releases of each package, so gcc  
4.2.1, binutils 2.17, make 3.81, and busybox.)

I agree squashfs and such aren't build time prerequisites. It might  
make more sense to move some of these to menuconfig text for the  
appropriate option. But that's not the same as not documenting it at  
all, and "this document has been true for a long time and remains true,  
therefore we must discard it" strikes me as a really weird document  
retention criteria.

Rob