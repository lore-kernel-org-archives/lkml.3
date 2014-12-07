Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaLGWSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:18:49 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaLGWSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:18:48 -0500
Message-ID: <5484D240.30506@nod.at>
Date: Sun, 07 Dec 2014 23:18:40 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: powerpc: kernel: signal_32.c:  Remove unused function
References: <1417990021-18696-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1417990021-18696-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.12.2014 um 23:07 schrieb Rickard Strandqvist:
> Remove the function sys_debug_setcontext() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.

Please don't blindly trust code analysis tools.
The function you're removing *is* in use.

  LD      init/built-in.o
arch/powerpc/kernel/built-in.o: In function `sys_call_table':
(.rodata+0x744): undefined reference to `sys_debug_setcontext'
make: *** [vmlinux] Error 1

Thanks,
//richard
