Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaGJKjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:39:36 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55078 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaGJKje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:39:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 1/3] asm-generic/io.h: Implement generic {read,write}s*()
Date: Thu, 10 Jul 2014 12:38:55 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407101238.56081.arnd@arndb.de>
X-Provags-ID: V02:K0:b8eDdKY5e1KXirLoEI1zZQpQlfrvPzcrwuMPgi8Idg/
 zFWPdWQpWViKnSM/235WqsX7P/FQIa8AFr+gntwsIkUsYKH01W
 jb1nCNSUfOAQv4+GQ++7hB+FDmdwLYE8As+npXw0FfxqmFnjXz
 Dz2triLmt4mBTGiH1YugVyuvvWrqwpYh3Zadhmu1hZMAujUF7G
 ubu79ZBprZtQA8TsyGeLTXylhm4sTGDAW686cCmK93ouF/bQzW
 +3MigeHDNbkMYOjQWkIJq9X0sMNhyQshBcYc4+GHEBIMyaJ6AF
 bGWFbB7OUkQ1BJ7ZHWiYfYpsP7iUXKrTgNGDqNRoqdRQhco6wU
 zSWpk8uWnkWJYZqb9YKsr/W/XjN9DcTBoCpRv0XvV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014, Thierry Reding wrote:
> 
> From: Thierry Reding <treding@nvidia.com>
> 
> This patch implements generic versions of readsb(), readsw(), readsl(),
> readsq(), writesb(), writesw(), writesl() and writesq(). Variants of
> these string functions for I/O accesses (ins*() and outs*() as well as
> ioread*_rep() and iowrite*_rep()) are now implemented in terms of the
> new functions.
> 
> While at it, also make sure that any of the functions provided as
> fallback for architectures that don't override them can't be overridden
> subsequently.
> 
> This is compile- and runtime-tested on 32-bit and 64-bit ARM and compile
> tested on Microblaze, s390, SPARC and Xtensa. For ARC, Blackfin, Metag,
> OpenRISC, Score and Unicore32 which also use asm-generic/io.h I couldn't
> find or build a cross-compiler that would run on my system. But by code
> inspection they shouldn't break with this patch.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks for doing this!

Not sure how to best merge the series, but for the asm-generic patch,
I'd suggest to keep it together with the follow-on patches in one
branch and merge it either through Russell's arm32 tree or through
Catalin's arm64 tree.

The easiest way would probably be to take patches 1 and 3 for arm64 in
3.17 and merge patch 2 in 3.18, unless Russell wants to see this earlier,
in which case we could have a branch that is shared between arm32 and
arm64.

	Arnd
