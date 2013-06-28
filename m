Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3F1OPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:15:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42814 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3F1OPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:15:13 -0400
Message-ID: <51CD9A62.3020404@zytor.com>
Date: Fri, 28 Jun 2013 07:14:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wedson Almeida Filho <wedsonaf@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Use asm-goto to implement mutex fast path on
 x86-64
References: <1372420245-60021-1-git-send-email-wedsonaf@gmail.com>
In-Reply-To: <1372420245-60021-1-git-send-email-wedsonaf@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 04:50 AM, Wedson Almeida Filho wrote:
> The new implementation allows the compiler to better optimize the code; the
> original implementation is still used when the kernel is compiled with older
> versions of gcc that don't support asm-goto.
> 
> Compiling with gcc 4.7.3, the original mutex_lock() is 60 bytes with the fast
> path taking 16 instructions; the new mutex_lock() is 42 bytes, with the fast
> path taking 12 instructions.
> 
> The original mutex_unlock() is 24 bytes with the fast path taking 7
> instructions; the new mutex_unlock() is 25 bytes (because the compiler used
> a 2-byte ret) with the fast path taking 4 instructions.
> 
> The two versions of the functions are included below for reference.
> 

As Ingo said, looks very nice.  However, it is really too late for Linux
3.11, so I'm going to put it on a queue I already have for 3.12.

	-hpa


