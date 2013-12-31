Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3LaOjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 09:39:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:45005 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3LaOjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 09:39:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,581,1384329600"; 
   d="scan'208";a="331277184"
Message-ID: <52C2D713.5050501@linux.intel.com>
Date: Tue, 31 Dec 2013 06:39:15 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, peterz@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk,
        ralf@linux-mips.org, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        james.hogan@imgtec.com, Michal Marek <mmarek@suse.cz>,
        lethal@linux-sh.org, shawn.guo@linaro.org,
        Kees Cook <keescook@chromium.org>, sfr@canb.auug.org.au,
        linux-kbuild@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [patch core/stackprotector] stackprotector: Fix build when compiler
 lacks support
References: <1387481759-14535-3-git-send-email-keescook@chromium.org> <tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org> <alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 1:37 PM, David Rientjes wrote:
> 8779657d29c0 ("stackprotector: Introduce CONFIG_CC_STACKPROTECTOR_STRONG")
> causes the build to break when the compiler doesn't support
> -fstack-protector-strong:
>
> 	cc1: error: unrecognized command line option ‘-fstack-protector-strong’
> 	cc1: error: unrecognized command line option ‘-fstack-protector-strong’
>
> with at least gcc 4.6.3.
>
> Instead of breaking the build, just warn of the failure and disable the
> feature.

ideally it also falls back to the less strict one, rather than not using stack protector at all...


