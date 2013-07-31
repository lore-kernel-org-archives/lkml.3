Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647Ab3GaS7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3GaS7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:59:04 -0400
Date: Wed, 31 Jul 2013 20:53:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zach@zachsthings.com>, Zach Levis <zml@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch added
	to -mm tree
Message-ID: <20130731185347.GA26439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Zach Levis <zml@linux.vnet.ibm.com>
> Subject: fs/binfmts: add a name field to the binfmt struct
>
> Adding the name field helps when printing error messages referring to
> specific binfmts.

OK, but...

>  static struct linux_binfmt elf_format = {
> +	.name		= "elf",
>  	.module		= THIS_MODULE,
>  	.load_binary	= load_elf_binary,
>  	.load_shlib	= load_elf_library,
> diff -puN fs/binfmt_elf_fdpic.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct fs/binfmt_elf_fdpic.c
> --- a/fs/binfmt_elf_fdpic.c~fs-binfmts-add-a-name-field-to-the-binfmt-struct
> +++ a/fs/binfmt_elf_fdpic.c
> @@ -81,6 +81,7 @@ static int elf_fdpic_core_dump(struct co
>  #endif
>
>  static struct linux_binfmt elf_fdpic_format = {
> +	.name		= "FDPIC ELF",

The naming doesn't look consistent, but this is minor.

I think this is not compat-friendly. If we add .name then I think
compat_elf_format should have another name != "elf".

Not that I think this is really wrong, but still.

Oleg.

