Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3LSORI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:17:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab3LSORH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:17:07 -0500
Date: Thu, 19 Dec 2013 15:17:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Timo_Ter=E4s?= <timo.teras@iki.fi>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] fs/binfmt_elf: fix memory map for PIE applications
In-Reply-To: <1380698395-5784-1-git-send-email-timo.teras@iki.fi>
Message-ID: <alpine.LNX.2.00.1312191516270.11852@pobox.suse.cz>
References: <1380698395-5784-1-git-send-email-timo.teras@iki.fi>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, Timo Teräs wrote:

> arch/*/include/asm/elf.h comments say:
>   ELF_ET_DYN_BASE is the location that an ET_DYN program is loaded
>   if exec'ed.  Typical use of this is to invoke "./ld.so someprog"
>   to test out a new version of the loader.  We need to make sure
>   that it is out of the way of the program that it will "exec",
>   and that there is sufficient room for the brk.
> 
> In case we have main application linked as PIE, this can cause
> problems as the main program itself is being loaded to this
> alternate address. And this allows limited heap size. While
> this is inevitable when exec'ing the interpreter directly,
> we should do better for PIE applications.

Timo,

could you please provide more specific example of the breakage scenario 
you are talking about? It's not completely clear to me from your commit 
message.

Thanks,

-- 
Jiri Kosina
SUSE Labs
