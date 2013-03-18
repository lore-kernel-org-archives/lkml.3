Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3CRSx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:53:59 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:63974 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3CRSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <1363602068-11924-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1363602068-11924-1-git-send-email-linfeng@cn.fujitsu.com>
Date: Mon, 18 Mar 2013 11:53:57 -0700
X-Google-Sender-Auth: I2dJf3LuPIkPakXS2l43iCC9udM
Message-ID: <CAE9FiQWuSL5Vq5VaAvQg_NT2gQJr17eMNoQbxtNJ8G3wweWNHQ@mail.gmail.com>
Subject: Re: [PATCH] x86: mm: accurate the comments for STEP_SIZE_SHIFT macro
From: Yinghai Lu <yinghai@kernel.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, penberg@kernel.org, jacob.shin@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:21 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
> For x86 PUD_SHIFT is 30 and PMD_SHIFT is 21, so the consequence of
> (PUD_SHIFT-PMD_SHIFT)/2 is 4. Update the comments to the code.
>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
> ---
>  arch/x86/mm/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 59b7fc4..637a95b 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -389,7 +389,7 @@ static unsigned long __init init_range_memory_mapping(
>         return mapped_ram_size;
>  }
>
> -/* (PUD_SHIFT-PMD_SHIFT)/2 */
> +/* (PUD_SHIFT-PMD_SHIFT)/2+1 */
>  #define STEP_SIZE_SHIFT 5
>  void __init init_mem_mapping(void)
>  {

9/2=4.5, so it becomes 5.
