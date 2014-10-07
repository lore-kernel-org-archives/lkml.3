Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaJGM1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:27:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46060 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbaJGM1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:27:15 -0400
Date: Tue, 7 Oct 2014 14:27:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH] Kbuild: Check for CONFIG_READABLE_ASM when building .s
 targets
Message-ID: <20141007122707.GD30146@pd.tnic>
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

On Tue, Oct 07, 2014 at 02:13:56PM +0200, Michal Marek wrote:
> This violates the principle of least surprise:
> 
> make $file.s
> as -o $file.o $file.s
> 
> should be equivalent to
> 
> make $file.o

I know but we need to enable -g for .s targets so that we get the .loc
annotation (i.e., line numbers) in asm which is very helpful.

But the least surprise principle is a valid point. Maybe we should warn
about it too when building .s targets...?

Or, maybe I should try to find out whether there's another gcc option
which adds ".loc" annotations alone...

> Why not simply check both READABLE_ASM and DEBUG_INFO?  Also, it's more
> straightforward to print the warning in the top-level Makefile rule than
> to add a conditional to the generic rule, like this:

The problem here is that we're building a couple of .s targets
regardless of what the make command contains, like bounds.s and such.

And we want to issue the warning only when we have an .s file as
an explicit target on the command line. That's why I'm doing that
asm_target assignment dance and something similar to WARN_ON_ONCE...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
