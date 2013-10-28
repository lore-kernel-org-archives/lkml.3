Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3J1NqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:46:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60393 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3J1NqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:46:00 -0400
Message-ID: <526E6A92.6090301@synopsys.com>
Date: Mon, 28 Oct 2013 19:15:54 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>, James Hogan <james.hogan@imgtec.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: use ASM_NL instead of ';' for assembler new line
 character in the macro
References: <526E3CE2.2070405@asianux.com>
In-Reply-To: <526E3CE2.2070405@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 04:00 PM, Chen Gang wrote:
> For some toolchains, they use another character as newline in a macro
> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
> macro) instead of ';' for it.
> 
> Since "linux/export.h" are mainly used for exporting work, then our fix
> more likely belongs to "linux/linkage.h", and we need add the related
> checking in "linkage.h".
> 
> Also need notice 80 columns wrap, and '\t' for each line.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arc/include/asm/linkage.h    |    2 +
>  include/asm-generic/vmlinux.lds.h |  350 +++++++++++++++++++------------------
>  include/linux/linkage.h           |   19 +

Like Max said, please drop the linker script bits - they are OK - otherwise ARC
kernel won't have been building at all.

And you also need to fix kernel/modsign_certificate.S as part of same patchset as
that is where the problem started in first place.

-Vineet
