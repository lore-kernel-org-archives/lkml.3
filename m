Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaEGWax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:30:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaEGWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:30:52 -0400
Date: Wed, 7 May 2014 15:30:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/1] kernel/profile.c: use static const char instead of
 static char
Message-Id: <20140507153050.70ad69194684f452bacc9bc8@linux-foundation.org>
In-Reply-To: <20140507223508.0fd3f59111f3d870859119fd@skynet.be>
References: <20140507223508.0fd3f59111f3d870859119fd@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 22:35:08 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> schedstr, sleepstr and kvmstr are only used in strcmp & strlen
> 
> ...
>
> --- a/kernel/profile.c
> +++ b/kernel/profile.c
> @@ -52,9 +52,9 @@ static DEFINE_MUTEX(profile_flip_mutex);
>  
>  int profile_setup(char *str)
>  {
> -	static char schedstr[] = "schedule";
> -	static char sleepstr[] = "sleep";
> -	static char kvmstr[] = "kvm";
> +	static const char schedstr[] = "schedule";
> +	static const char sleepstr[] = "sleep";
> +	static const char kvmstr[] = "kvm";
>  	int par;
>  

I'd expect this to either make no change or to make text larger and
data smaller.

In fact,

   text    data     bss     dec     hex filename
   7631     811    3016   11458    2cc2 kernel/profile.o-before
   7520     779    3016   11315    2c33 kernel/profile.o-after

Both text and data got smaller and the total reduction was a whopping
143 bytes.   Weirdness.

