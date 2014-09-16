Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaIPIgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:36:24 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63630 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaIPIgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:36:23 -0400
Date: Tue, 16 Sep 2014 10:36:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Michele Curti <michele.curti@gmail.com>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/vdso: use NULL instead of zero
Message-ID: <20140916083618.GA1712@gmail.com>
References: <20140915143939.GA1953@powerline.azcom-win.it>
 <20140916065732.GA19849@gmail.com>
 <20140916083109.GA802@powerline.azcom-win.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916083109.GA802@powerline.azcom-win.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michele Curti <michele.curti@gmail.com> wrote:

> 
> x86/vdso: use NULL instead of zero in patch_vdso32()
> 
> Signed-off-by: Michele Curti <michele.curti@gmail.com>
> 
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 1ad1026..a4647bc 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -34,7 +34,7 @@ static unsigned vdsox32_size;
>  void __init patch_vdso32(void *vdso, size_t len)
>  {
>  	Elf32_Ehdr *hdr = vdso;
> -	Elf32_Shdr *sechdrs, *alt_sec = 0;
> +	Elf32_Shdr *sechdrs, *alt_sec = NULL;
>  	char *secstrings;
>  	void *alt_data;
>  	int i;

Your patch does not apply, this code got significantly reworked 
in the following commit, earlier this year:

  6f121e548f83 x86, vdso: Reimplement vdso.so preparation in build-time C

Thanks,

	Ingo
