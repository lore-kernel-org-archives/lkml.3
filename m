Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaCEIo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:44:27 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61910 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaCEIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:44:25 -0500
Date: Wed, 5 Mar 2014 09:44:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] random: Use arch_get_random_seed*() at init time and
 once a second
Message-ID: <20140305084421.GB2705@gmail.com>
References: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
 <1393972815-16689-3-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393972815-16689-3-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Use arch_get_random_seed*() in two places in the Linux random
> driver (drivers/char/random.c):
> 
> 1. During entropy pool initialization, use RDSEED in favor of RDRAND,
>    with a fallback to the latter.  Entropy exhaustion is unlikely to
>    happen there on physical hardware as the machine is single-threaded
>    at that point, but could happen in a virtual machine.  In that
>    case, the fallback to RDRAND will still provide more than adequate
>    entropy pool initialization.
> 
> 2. Once a second, issue RDSEED and, if successful, feed it to the
>    entropy pool.  To ensure an extra layer of security, only credit
>    half the entropy just in case.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  drivers/char/random.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
