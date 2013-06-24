Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FXJeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:34:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41624 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3FXJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:34:06 -0400
Date: Mon, 24 Jun 2013 10:34:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20130624093403.GY4165@ZenIV.linux.org.uk>
References: <20130624113540.dd2911f4d0a4732635eb2aa7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624113540.dd2911f4d0a4732635eb2aa7@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 11:35:40AM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from arch/powerpc/xmon/xmon.c:41:0:
> arch/powerpc/include/asm/spu.h:245:43: error: 'struct coredump_params' declared inside parameter list [-Werror]
>   int (*coredump_extra_notes_write)(struct coredump_params *cprm);
>                                            ^
> arch/powerpc/include/asm/spu.h:245:43: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
> 
> Caused by commit 27e58d7e7e6d ("[needs split] switch to saner coredump
> primitives").  Presumably, arch/powerpc/include/asm/spu.h needs to
> include linux/binfmts.h or just forward declare "struct coredump_params".

Mea culpa - it's missing forward + missing include of linux/coredump.h
in spufs/coredump.c.  I've fixed that and moved that commit to the end
of queue - it *does* need a splitup, so it'll get replaced with
several commits anyway.
