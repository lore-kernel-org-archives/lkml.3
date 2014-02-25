Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaBYLfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:35:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44326 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaBYLf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:35:28 -0500
Date: Tue, 25 Feb 2014 12:35:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140225113524.GA23256@pd.tnic>
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <530C7465.2080600@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:45:57AM -0800, H. Peter Anvin wrote:
> On 02/24/2014 10:01 PM, Chris Bainbridge wrote:
> >Pentium M is PAE capable but does not indicate so in the CPUID response.
> >This is an issue now that some distributions are no longer shipping
> >non-PAE kernels (those distributions no longer boot on Pentium M). This
> >small patch fixes the issue by forcing the PAE capability on Pentium M.
> >
> >For more discussion see https://bugs.launchpad.net/baltix/+bug/930447
> >
> 
> 1. This patch doesn't match the discussion in the link.
> 2. You would have to also enable this in the cpu testing code in
>    arch/x86/boot.
> 3. At the very least we need to print a serious warning that the CPU
>    is being run outside its specifications.  I have no personal
>    information about why this CPUID bit was disabled, but it could be
>    that it was discovered in testing that it didn't work correctly in
>    all circumstances (e.g. high temperature.)  This is very much "use
>    at your own risk..."; you could get data corruption or even
>    hardware damage.
> 
>    We should probably also taint the kernel.

Right, I was about to say that. And since there's no special bit for
running "out-of-spec", we could probably repurpose

TAINT_UNSAFE_SMP - 'S' - SMP with CPUs not designed for SMP.

to

TAINT_UNSAFE_OUT_OF_SPEC (the letter S fits still) and add that taint
everytime we're enforcing functionality against doctor's orders, so to
speak. :-)

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
