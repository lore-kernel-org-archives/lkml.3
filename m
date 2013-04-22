Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3DVJZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:25:14 -0400
Received: from ozlabs.org ([203.10.76.45]:41243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab3DVJZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:25:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] initconst fixes for module signing
In-Reply-To: <1366515778-18039-1-git-send-email-andi@firstfloor.org>
References: <1366515778-18039-1-git-send-email-andi@firstfloor.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Apr 2013 14:35:13 +0930
Message-ID: <87obd79muu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
> From: Andi Kleen <ak@linux.intel.com>
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Thanks, applied.

Cheers,
Rusty.

> diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
> index 2b6e699..7cbd450 100644
> --- a/kernel/modsign_pubkey.c
> +++ b/kernel/modsign_pubkey.c
> @@ -18,14 +18,14 @@
>  
>  struct key *modsign_keyring;
>  
> -extern __initdata const u8 modsign_certificate_list[];
> -extern __initdata const u8 modsign_certificate_list_end[];
> +extern __initconst const u8 modsign_certificate_list[];
> +extern __initconst const u8 modsign_certificate_list_end[];
>  
>  /*
>   * We need to make sure ccache doesn't cache the .o file as it doesn't notice
>   * if modsign.pub changes.
>   */
> -static __initdata const char annoy_ccache[] = __TIME__ "foo";
> +static __initconst const char annoy_ccache[] = __TIME__ "foo";
>  
>  /*
>   * Load the compiled-in keys
