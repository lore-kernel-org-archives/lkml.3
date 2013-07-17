Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3GQTye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:54:34 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:37640 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3GQTyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:54:31 -0400
MIME-Version: 1.0
In-Reply-To: <1373994280-12047-3-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net> <1373994280-12047-3-git-send-email-rth@twiddle.net>
From: Matt Turner <mattst88@gmail.com>
Date: Wed, 17 Jul 2013 12:54:10 -0700
Message-ID: <CAEdQ38FbgCRWVrvbt6rB713QvqHtY3aQqYLp=G6WG50=OnYFKg@mail.gmail.com>
Subject: Re: [PATCH 2/7] alpha: Eliminate compiler warning from memset macro
To: Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
        linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:04 AM, Richard Henderson <rth@twiddle.net> wrote:
> Compiling with GCC 4.8 yields several instances of
>
> crypto/vmac.c: In function ‘vmac_final’:
> crypto/vmac.c:616:9: warning: value computed is not used [-Wunused-value]
>   memset(&mac, 0, sizeof(vmac_t));
>          ^
> arch/alpha/include/asm/string.h:31:25: note: in definition of macro ‘memset’
>      ? __builtin_memset((s),0,(n))          \
>                          ^
> Converting the macro to an inline function eliminates this problem.
>
> Signed-off-by: Richard Henderson <rth@twiddle.net>
> ---

On IRC we found out that this breaks the breaks kernel build with
gcc-3.4 with "sorry, unimplemented: inlining failed in call to
'memset': recursive  inlining" message on some file. I'll drop this
patch for now.
