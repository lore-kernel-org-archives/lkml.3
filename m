Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbaDVO3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:29:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49236 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751034AbaDVO3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:29:01 -0400
Date: Tue, 22 Apr 2014 11:28:31 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH 05/28] nios2: Traps exception handling
Message-ID: <20140422142831.GC15745@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397845149-3141-1-git-send-email-lftan@altera.com>
 <1397845149-3141-2-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397845149-3141-2-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ley Foon,

On Apr 19, Ley Foon Tan wrote:
> +
> +#ifndef CONFIG_ALIGNMENT_TRAP
> +/* Alignment exception handler */
> +asmlinkage void handle_unaligned_c(struct pt_regs *fp, int cause)
> +{
> +	unsigned long addr = RDCTL(CTL_BADADDR);
> +
> +	cause >>= 2;
> +	fp->ea -= 4;
> +
> +	if (fixup_exception(fp))
> +		return;

This will throw an undeclared error if you build with CONFIG_ALIGNMENT_TRAP=n.

You need to add the uaccess.h header, or implement some similar fix.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
