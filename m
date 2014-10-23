Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaJWTZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:25:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41503 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbaJWTZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:25:00 -0400
Date: Thu, 23 Oct 2014 21:24:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH] Kbuild: Check for CONFIG_READABLE_ASM when building .s
 targets
Message-ID: <20141023192456.GC4619@pd.tnic>
References: <1412523154-25602-1-git-send-email-bp@alien8.de>
 <20141005155816.GB9377@pd.tnic>
 <20141007121356.GA18003@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141007121356.GA18003@sepie.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Michal,

On Tue, Oct 07, 2014 at 02:13:56PM +0200, Michal Marek wrote:
> This violates the principle of least surprise:
> 
> make $file.s
> as -o $file.o $file.s
> 
> should be equivalent to
> 
> make $file.o

on a second thought, I think we don't care about this. Because we build
the objects in kbuild with make and not with gas directly. IOW, we never
use the intermittent product file.s when building file.o but we start
again from file.c.

And besides, even if we did use gas, we would still need to pass
KBUILD_AFLAGS to it.

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
