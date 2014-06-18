Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965792AbaFRKKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:10:55 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:40847 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965039AbaFRKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:10:54 -0400
Date: Wed, 18 Jun 2014 11:10:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: fix build error in sigcontext.h
Message-ID: <20140618101039.GA14680@arm.com>
References: <1402517682-13061-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402517682-13061-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 09:14:42PM +0100, Mark Salter wrote:
> I'm seeing this build failure for arm64:
> 
>     CC [M]  Documentation/filesystems/configfs/configfs_example_macros.o
>   In file included from /usr/include/bits/sigcontext.h:27:0,
>                    from /usr/include/signal.h:340,
>                    from /usr/include/sys/wait.h:30,
>                    from Documentation/accounting/getdelays.c:24:
>   .../linux/usr/include/asm/sigcontext.h:61:2: error: unknown type name ‘u64’
>     u64 esr;
>     ^
>   make[2]: *** [Documentation/accounting/getdelays] Error 1
> 
> This was introduced by commit 15af1942dd61ee23:
> 
>   arm64: Expose ESR_EL1 information to user when SIGSEGV/SIGBUS
> 
> Using __u64 instead of u64 fixes the problem.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Applied. Thanks.

-- 
Catalin
