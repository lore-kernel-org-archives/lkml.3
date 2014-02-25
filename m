Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaBYKqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:46:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52720 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaBYKqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:46:08 -0500
Message-ID: <530C7465.2080600@zytor.com>
Date: Tue, 25 Feb 2014 02:45:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chris Bainbridge <chris.bainbridge@gmail.com>, x86@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
References: <20140225060146.GA4339@debian.local>
In-Reply-To: <20140225060146.GA4339@debian.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 10:01 PM, Chris Bainbridge wrote:
> Pentium M is PAE capable but does not indicate so in the CPUID response.
> This is an issue now that some distributions are no longer shipping
> non-PAE kernels (those distributions no longer boot on Pentium M). This
> small patch fixes the issue by forcing the PAE capability on Pentium M.
>
> For more discussion see https://bugs.launchpad.net/baltix/+bug/930447
>

1. This patch doesn't match the discussion in the link.
2. You would have to also enable this in the cpu testing code in
    arch/x86/boot.
3. At the very least we need to print a serious warning that the CPU
    is being run outside its specifications.  I have no personal
    information about why this CPUID bit was disabled, but it could be
    that it was discovered in testing that it didn't work correctly in
    all circumstances (e.g. high temperature.)  This is very much "use
    at your own risk..."; you could get data corruption or even
    hardware damage.

    We should probably also taint the kernel.

	-hpa


