Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaKDULH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:11:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaKDULF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:11:05 -0500
Message-ID: <545932C3.3080907@zytor.com>
Date: Tue, 04 Nov 2014 12:10:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: mingo@kernel.org, linux-kernel@vger.kernel.org, JBeulich@suse.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/boot] x86-64: Use RIP-relative addressing for most per-CPU
 accesses
References: <5458A1780200007800044A9D@mail.emea.novell.com> <tip-97b67ae559947f1e208439a1bf6a734da3087006@git.kernel.org>
In-Reply-To: <tip-97b67ae559947f1e208439a1bf6a734da3087006@git.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 11:45 AM, tip-bot for Jan Beulich wrote:
> Commit-ID:  97b67ae559947f1e208439a1bf6a734da3087006
> Gitweb:     http://git.kernel.org/tip/97b67ae559947f1e208439a1bf6a734da3087006
> Author:     Jan Beulich <JBeulich@suse.com>
> AuthorDate: Tue, 4 Nov 2014 08:50:48 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 4 Nov 2014 20:43:14 +0100
> 
> x86-64: Use RIP-relative addressing for most per-CPU accesses
> 
> Observing that per-CPU data (in the SMP case) is reachable by
> exploiting 64-bit address wraparound (building on the default kernel
> load address being at 16Mb), the one byte shorter RIP-relative
> addressing form can be used for most per-CPU accesses. The one
> exception are the "stable" reads, where the use of the "P" operand
> modifier prevents the compiler from using RIP-relative addressing, but
> is unavoidable due to the use of the "p" constraint (side note: with
> gcc 4.9.x the intended effect of this isn't being achieved anymore,
> see gcc bug 63637).
> 
> With the dependency on the minimum kernel load address, arbitrarily
> low values for CONFIG_PHYSICAL_START are now no longer possible. A
> link time assertion is being added, directing to the need to increase
> that value when it triggers.
> 

This description makes very little sense.  What matters here is the
virtual address, which is always >= -2 GB.

	-hpa


