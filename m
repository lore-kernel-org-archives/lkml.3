Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaDKSMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:12:30 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50605 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaDKSM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:12:27 -0400
Message-ID: <53483088.1010407@amacapital.net>
Date: Fri, 11 Apr 2014 11:12:24 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt:  Ban 16-bit segments on
 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
In-Reply-To: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:36 AM, tip-bot for H. Peter Anvin wrote:
> Commit-ID:  b3b42ac2cbae1f3cecbb6229964a4d48af31d382
> Gitweb:     http://git.kernel.org/tip/b3b42ac2cbae1f3cecbb6229964a4d48af31d382
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Sun, 16 Mar 2014 15:31:54 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 11 Apr 2014 10:10:09 -0700
> 
> x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
> 
> The IRET instruction, when returning to a 16-bit segment, only
> restores the bottom 16 bits of the user space stack pointer.  We have
> a software workaround for that ("espfix") for the 32-bit kernel, but
> it relies on a nonzero stack segment base which is not available in
> 32-bit mode.
> 
> Since 16-bit support is somewhat crippled anyway on a 64-bit kernel
> (no V86 mode), and most (if not quite all) 64-bit processors support
> virtualization for the users who really need it, simply reject
> attempts at creating a 16-bit segment when running on top of a 64-bit
> kernel.
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Link: http://lkml.kernel.org/n/tip-kicdm89kzw9lldryb1br9od0@git.kernel.org
> Cc: <stable@vger.kernel.org>

If this is what I think it is (hi, Spender), then it is probably only
useful for 3.14.y and not earlier kernels.

--Andy
