Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaBYMIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:08:00 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40977 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBYMH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:07:58 -0500
Date: Tue, 25 Feb 2014 12:07:43 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140225120743.6ed967ed@alan.etchedpixels.co.uk>
In-Reply-To: <530C7465.2080600@zytor.com>
References: <20140225060146.GA4339@debian.local>
	<530C7465.2080600@zytor.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014 02:45:57 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/24/2014 10:01 PM, Chris Bainbridge wrote:
> > Pentium M is PAE capable but does not indicate so in the CPUID response.
> > This is an issue now that some distributions are no longer shipping
> > non-PAE kernels (those distributions no longer boot on Pentium M). This
> > small patch fixes the issue by forcing the PAE capability on Pentium M.
> >
> > For more discussion see https://bugs.launchpad.net/baltix/+bug/930447
> >
> 
> 1. This patch doesn't match the discussion in the link.
> 2. You would have to also enable this in the cpu testing code in
>     arch/x86/boot.
> 3. At the very least we need to print a serious warning that the CPU
>     is being run outside its specifications.  I have no personal
>     information about why this CPUID bit was disabled, but it could be
>     that it was discovered in testing that it didn't work correctly in
>     all circumstances (e.g. high temperature.)  This is very much "use
>     at your own risk..."; you could get data corruption or even
>     hardware damage.

A hang with an extended version of the no PAE message that warns you
and then says "Boot with the option "forcepae" to bypass this check",
would, IMHO, be a bit wiser, unless someone can actually dig out the
reason it does not advertise the flag.

Alan
