Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaLRQ7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:59:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaLRQ7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:59:47 -0500
Message-ID: <549307F0.7090009@zytor.com>
Date: Thu, 18 Dec 2014 08:59:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, luto@amacapital.net,
        torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/tls: Don't validate lm in set_thread_area()
 after all
References: <d7875b60e28c512f6a6fc0baf5714d58e7eaadbb.1418856405.git.luto@amacapital.net> <tip-3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0@git.kernel.org>
In-Reply-To: <tip-3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0@git.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 03:16 AM, tip-bot for Andy Lutomirski wrote:
> Commit-ID:  3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0
> Gitweb:     http://git.kernel.org/tip/3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0
> Author:     Andy Lutomirski <luto@amacapital.net>
> AuthorDate: Wed, 17 Dec 2014 14:48:30 -0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 18 Dec 2014 12:12:26 +0100
> 
> x86/tls: Don't validate lm in set_thread_area() after all
> 
> It turns out that there's a lurking ABI issue.  GCC, when
> compiling this in a 32-bit program:
> 
> struct user_desc desc = {
> 	.entry_number    = idx,
> 	.base_addr       = base,
> 	.limit           = 0xfffff,
> 	.seg_32bit       = 1,
> 	.contents        = 0, /* Data, grow-up */
> 	.read_exec_only  = 0,
> 	.limit_in_pages  = 1,
> 	.seg_not_present = 0,
> 	.useable         = 0,
> };
> 
> will leave .lm uninitialized.  This means that anything in the
> kernel that reads user_desc.lm for 32-bit tasks is unreliable.
> 

No, it won't.  However, if you initialize this dynamically field by
field rather than as an initializer, then you are correct.

	-hpa

