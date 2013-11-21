Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab3KUAkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:40:24 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40371 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3KUAkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:40:20 -0500
MIME-Version: 1.0
In-Reply-To: <1384978798-2183-1-git-send-email-geyslan@gmail.com>
References: <1384978798-2183-1-git-send-email-geyslan@gmail.com>
Date: Wed, 20 Nov 2013 22:40:19 -0200
Message-ID: <CAGG-pUSPw3caXrGBuOt+o50n=gtRv=eHC24NN8=z28sr_Ton3A@mail.gmail.com>
Subject: Re: [PATCH] fs: binfmt_elf: Add two ELF header consistency checks
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: kernel-br <kernel-br@googlegroups.com>,
        "Geyslan G. Bem" <geyslan@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:FILESYSTEMS (VFS...)" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/20 Geyslan G. Bem <geyslan@gmail.com>:
> The member 'e_ehsize' that holds the ELF header size is compared
> with the elfhdr struct size. If not equal, goes out.
> If 'e_phoff' holds 0 the object has no program header table, so
> goes out.
>
> Increasing the binary consistency reduces the use of malformed ones.
>
> Both checks are in accordance with the ELF Specifications.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/binfmt_elf.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 571a423..3c08f96 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -603,6 +603,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
>         if (memcmp(loc->elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
>                 goto out;
>
> +       if (loc->elf_ex.e_ehsize != sizeof(struct elfhdr))
> +               goto out;
>         if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
>                 goto out;
>         if (!elf_check_arch(&loc->elf_ex))
> @@ -611,6 +613,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
>                 goto out;
>
>         /* Now read in all of the header information */
> +       if (loc->elf_ex.e_phoff == 0)
> +               goto out;
>         if (loc->elf_ex.e_phentsize != sizeof(struct elf_phdr))
>                 goto out;
>         if (loc->elf_ex.e_phnum < 1 ||
> --
> 1.8.4.2
>

PATCH v2 Sent:
[PATCH v2] fs: binfmt_elf: Add ELF header consistency checks

-- 
Regards,

Geyslan G. Bem
hackingbits.com
