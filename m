Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3IIItk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:49:40 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38884 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3IIIth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:49:37 -0400
Date: Mon, 9 Sep 2013 10:49:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH] x86, build: move build output statistics away from stderr
Message-ID: <20130909084933.GA20140@gmail.com>
References: <20130906181532.GA31260@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906181532.GA31260@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> When building on x86, the final image building step always emits stats
> to stderr, even though this information is neither a warning nor an error:
> 
>   BUILD   arch/x86/boot/bzImage
> Setup is 16188 bytes (padded to 16384 bytes).
> System is 6368 kB
> CRC cbe50c61
> 
> Validating automated builds would be cleaner if stderr did not have to 
> filter out these lines. Instead, change how tools/build is called, and 
> make the zoffset header unconditional, and write to a specified file 
> instead of to stdout, which can then be used for statistics, leaving 
> stderr open for legitimate warnings and errors, like the output from 
> die().

Nice, that output to stderr was always somewhat annoying.

> +	/* Catch any delayed write failures */
> +	if (fclose(dest))
> +		die("Writing image failed");
> +
>  	close(fd);

Looks like the new code is not just reporting errors better, but it's more 
robust by catching and reporting fclose()-time failures as well, avoiding 
a corrupt kernel image in certain corner cases - the most common being a 
file system full error I suspect.

Thanks,

	Ingo
