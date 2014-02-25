Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaBYRQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:16:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57761 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaBYRQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:16:23 -0500
Message-ID: <530CCFD2.3050007@zytor.com>
Date: Tue, 25 Feb 2014 09:16:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Chris Bainbridge <chris.bainbridge@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
References: <20140225060146.GA4339@debian.local> <530C7465.2080600@zytor.com> <20140225162611.GA31902@redhat.com>
In-Reply-To: <20140225162611.GA31902@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 08:26 AM, Dave Jones wrote:
> On Tue, Feb 25, 2014 at 02:45:57AM -0800, H. Peter Anvin wrote:
>  > On 02/24/2014 10:01 PM, Chris Bainbridge wrote:
>  > > Pentium M is PAE capable but does not indicate so in the CPUID response.
>  > > This is an issue now that some distributions are no longer shipping
>  > > non-PAE kernels (those distributions no longer boot on Pentium M). This
>  > > small patch fixes the issue by forcing the PAE capability on Pentium M.
>  > >
>  > > For more discussion see https://bugs.launchpad.net/baltix/+bug/930447
>  > >
>  > 
>  > 1. This patch doesn't match the discussion in the link.
>  > 2. You would have to also enable this in the cpu testing code in
>  >     arch/x86/boot.
>  > 3. At the very least we need to print a serious warning that the CPU
>  >     is being run outside its specifications.  I have no personal
>  >     information about why this CPUID bit was disabled, but it could be
>  >     that it was discovered in testing that it didn't work correctly in
>  >     all circumstances (e.g. high temperature.)  This is very much "use
>  >     at your own risk..."; you could get data corruption or even
>  >     hardware damage.
> 
> About six years ago, we almost went down this same path for Fedora,
> and I'm fairly sure the only reason we backed off and decided to not
> pursue it was that we found some Pentium M's where it just didn't work.
> 

OK, that *definitely* means that if we're doing this at all we're doing
it via an explicit opt-in on the command line, and tainting the kernel
in the process.

I don't know if anyone (Chris?) is interested enough in the problem to
do such a patch, though.  I know I'm not too interested in spending a
bunch of time on.

	-hpa

