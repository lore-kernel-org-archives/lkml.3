Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3HGKyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:54:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55670 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689Ab3HGKyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:54:10 -0400
Date: Wed, 7 Aug 2013 12:54:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Akinobu Mita <mita@miraclelinux.com>
Subject: Re: [PATCH] bitops: move BITS() macro to the bitops file
Message-ID: <20130807105408.GB18272@pd.tnic>
References: <1375866379-27504-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1375866379-27504-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 11:06:19AM +0200, Linus Walleij wrote:
> This macro was invented by Mattias Nilsson for the usecase
> where you want to set a sequence of bits inside a n-bit
> word, while leaving the head and tail of the sequence all
> zeroes. For example:
> 
>   #include <linux/bitops.h>
> 
>   u16 mask = BITS(4, 12);
> 
> Yields a mask like this:
> 
>   0001111111110000
> 
> This patch moves the construct out of the MFD PRCMU driver
> and make it available for common use, after noticing in a
> review or two that it would be useful for others.

Well, we have similar GEN_MASK and GENMASK macros around the tree. Maybe
we could unify them all?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
