Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab3BOTDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:03:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36987 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3BOTDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:03:14 -0500
Message-ID: <511E8659.6030601@zytor.com>
Date: Fri, 15 Feb 2013 11:02:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, coreyb@linux.vnet.ibm.com,
        wad@chromium.org
Subject: Re: [PATCH] x86: remove the x32 syscall bitmask from syscall_get_nr()
References: <20130215172143.12549.10292.stgit@localhost>
In-Reply-To: <20130215172143.12549.10292.stgit@localhost>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 09:21 AM, Paul Moore wrote:
> Commit fca460f95e928bae373daa8295877b6905bc62b8 simplified the x32
> implementation by creating a syscall bitmask, equal to 0x40000000, that
> could be applied to x32 syscalls such that the masked syscall number
> would be the same as a x86_64 syscall.  While that patch was a nice
> way to simplify the code, it went a bit too far by adding the mask to
> syscall_get_nr(); returning the masked syscall numbers can cause
> confusion with callers that expect syscall numbers matching the x32
> ABI, e.g. unmasked syscall numbers.
> 
> This patch fixes this by simply removing the mask from syscall_get_nr()
> while preserving the other changes from the original commit.  While
> there are several syscall_get_nr() callers in the kernel, most simply
> check that the syscall number is greater than zero, in this case this
> patch will have no effect.  Of those remaining callers, they appear
> to be few, seccomp and ftrace, and from my testing of seccomp without
> this patch the original commit definitely breaks things; the seccomp
> filter does not correctly filter the syscalls due to the difference in
> syscall numbers in the BPF filter and the value from syscall_get_nr().
> Applying this patch restores the seccomp BPF filter functionality on
> x32.
> 
> I've tested this patch with the seccomp BPF filters as well as ftrace
> and everything looks reasonable to me; needless to say general usage
> seemed fine as well.
> 

Hi... it isn't 100% clear from the description if you have audited *all*
the callers?

	-hpa


