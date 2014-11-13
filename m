Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaKMAiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:38:15 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:57076 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbaKMAiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:38:13 -0500
Date: Thu, 13 Nov 2014 01:16:19 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Paul Burton <paul.burton@imgtec.com>, linux-mips@linux-mips.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] binfmt_elf: allow arch code to examine PT_LOPROC
 ... PT_HIPROC headers
Message-ID: <20141113001618.GC3839@linux-mips.org>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
 <1410420623-11691-4-git-send-email-paul.burton@imgtec.com>
 <20141112134059.GA12619@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112134059.GA12619@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:41:04PM +0100, Thierry Reding wrote:

> Hi Ralf,
> 
> This commit showed up in linux-next and causes a warning in linux/elf.h
> because it doesn't know struct file. I've fixed it locally with this:
> 
> ---
> diff --git a/include/linux/elf.h b/include/linux/elf.h
> index 6bd15043a585..dac5caaa3509 100644
> --- a/include/linux/elf.h
> +++ b/include/linux/elf.h
> @@ -4,6 +4,8 @@
>  #include <asm/elf.h>
>  #include <uapi/linux/elf.h>
>  
> +struct file;
> +
>  #ifndef elf_read_implies_exec
>    /* Executables for which elf_read_implies_exec() returns TRUE will
>       have the READ_IMPLIES_EXEC personality flag set automatically.
> ---
> 
> Would you mind squashing that into the above commit to get rid of the
> warning?

To fix the warnings reported by sfr on powerpc64 this morning I moved
most of the code added to <linux/elf.h> into fs/binfmt_elf.c.  That
should also have taken care of the warnings you saw for ARM.

  Ralf
