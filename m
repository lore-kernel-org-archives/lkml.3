Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaE1ToR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:44:17 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50830 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaE1ToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:44:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel Porquet <joel@porquet.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: uaccess: avoid name conflicts for strncpy and str(n)len
Date: Wed, 28 May 2014 21:44:12 +0200
Message-ID: <9795542.Hus6bU8DVG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1401290511-10211-1-git-send-email-joel@porquet.org>
References: <1401290511-10211-1-git-send-email-joel@porquet.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SxsnqHLxAo/VL4Oosu182CKxkniDYXhOj4vzYZSISZB
 f7CZ1N2qFx53cmsM0q7RyoMHpZO+P0R32ig5AplboaK63g0VbW
 u/WqA1zpAFPfsptBcxTS6mWnRIwyMyj4enmZ29nrjAW6LdTiS8
 2Pl3qW52N8T2R3N6zy5GCMzDJ59E9uRYpot1RC+5317j+wY7On
 ivUtOlpFi3ZYnbWWp8YZkfoE/ObMCZijUuq8oF/g3QUctl7Xre
 E72llQFYAq+PDU0qrM0zUVy9JI2gsx5YAQSy4RkKbvzyGNTXvG
 ND5c4eX9OpKuNSvU6qmstVSNXzcVs+06kKaDI6CPJUgaMiwp9Q
 lky6sLrKLn5+rzJKuYv8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2014 17:21:51 Joel Porquet wrote:
> asm-generic/uaccess.h defines 'strncpy_from_user', 'strnlen_user' and
> 'strlen_user' as static inline functions. It makes it impossible for an
> arch to include asm-generic/uaccess.h and benefits from its content, in
> addition to defining GENERIC_STRNCPY_FROM_USER and GENERIC_STRNLEN_USER.
> 
> Both configuration tokens respectively enable lib/strncpy_from_user.c
> and lib/strnlen_user.c which redefine the same symbols, causing
> redefinition errors at compilation.
> 
> This patch modifies asm-generic/uaccess.h so that strncpy_from_user is
> not defined when GENERIC_STRNCPY_FROM_USER is, and strnlen_user and
> strlen_user are not defined when GENERIC_STRNLEN_USER is, thus avoiding
> any name conflict.
> 
> At the moment, numerous archs, which make use of
> GENERIC_STRNCPY_FROM_USER and GENERIC_STRNLEN_USER, are forced to
> rewrite an entire asm/uaccess.h header because of this issue.
> 
> To the best of my knowledge, the following list of archs could benefit
> from this patch: x86, sh, openrisc, powerpc, arm64, arm, alpha, parisc,
> sparc, m68k.
> 
> Signed-off-by: Joel Porquet <joel@porquet.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

It makes sense to do this for any architecture that want's to use
this file, so feel free to add your patch the tree of whatever architecture
you want to convert.

Note however that asm/uaccess.h can't be implemented correctly in
generic code: you always need inline assembly to add the correct fixup
section magic.

	Arnd
