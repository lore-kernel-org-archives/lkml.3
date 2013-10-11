Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3JKU5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:57:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3JKU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:57:06 -0400
Date: Fri, 11 Oct 2013 13:57:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jump_label: unlikely(x) > 0
Message-Id: <20131011135704.6fd455e2387a37f1972a4e0f@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1310112241220.11060@Z>
References: <alpine.DEB.2.02.1310112241220.11060@Z>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 22:50:50 +0200 (CEST) Roel Kluin <roel.kluin@gmail.com> wrote:

> untested, but wasn't this intended instead?
> --------------
> if (unlikely(x) > 0) doesn't seem to help branch prediction
> 
> ...
>
> --- a/include/linux/jump_label.h
> +++ b/include/linux/jump_label.h
> @@ -132,14 +132,14 @@ static __always_inline void jump_label_init(void)
>  
>  static __always_inline bool static_key_false(struct static_key *key)
>  {
> -	if (unlikely(atomic_read(&key->enabled)) > 0)
> +	if (unlikely(atomic_read(&key->enabled) > 0))
>  		return true;
>  	return false;
>  }
>  
>  static __always_inline bool static_key_true(struct static_key *key)
>  {
> -	if (likely(atomic_read(&key->enabled)) > 0)
> +	if (likely(atomic_read(&key->enabled) > 0))
>  		return true;
>  	return false;
>  }

I'm sure this was intended instead ;) The patch doesn't seem to make
any difference in code generation with my gcc.

