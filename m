Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3HFXj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:39:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48261 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753740Ab3HFXj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:39:56 -0400
Message-ID: <1375832393.2424.47.camel@joe-AO722>
Subject: Re: [PATCH 1/1] module: fix sprintf format specifier in
 param_get_byte()
From: Joe Perches <joe@perches.com>
To: Christoph Jaeger <christophjaeger@linux.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 16:39:53 -0700
In-Reply-To: <1375823532-24153-1-git-send-email-christophjaeger@linux.com>
References: <1375823532-24153-1-git-send-email-christophjaeger@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 23:12 +0200, Christoph Jaeger wrote:
> In param_get_byte(), to which the macro STANDARD_PARAM_DEF(byte, ...) expands,
> "%c" is used to print an unsigned char. So it gets printed as a character what
> is not intended here. Use "%hhu" instead.
> 
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
> ---
>  kernel/params.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/params.c b/kernel/params.c
> index 440e65d..59f7ac7 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -252,7 +252,7 @@ int parse_args(const char *doing,
>  	EXPORT_SYMBOL(param_ops_##name)
>  
> 
> -STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
> +STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, strict_strtoul);
>  STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
>  STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);

I don't see the point of using "%hh[ui]" and "%h[ui]".
These are promoted to int/unsigned int for the sprintf anyway.
I'd just use %d and %u instead.


