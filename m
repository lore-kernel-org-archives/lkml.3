Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaHLAmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 20:42:32 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57958 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaHLAmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 20:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140809030822.GA9422@gondor.apana.org.au>
References: <20140808075316.GA21919@www.outflux.net> <CALZtONBNEg7kzUtwKihQuAU48MNh5NjhZcWoOxe-1-vgWqSLiw@mail.gmail.com>
 <CAGXu5jL3GjrqsixS6U+GYD1pxAOOcXsXbt5XOVC8KhZB+naXAA@mail.gmail.com> <20140809030822.GA9422@gondor.apana.org.au>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 11 Aug 2014 20:42:10 -0400
X-Google-Sender-Auth: L_ZQg9u90QvvdzAWnyXCVnnGfik
Message-ID: <CALZtONCRexP81eAAGEDt39g=WS=Dw7UOp0L-ip_SHSpaSE8QzA@mail.gmail.com>
Subject: Re: [PATCH] mm/zpool: use prefixed module loading
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux-MM <linux-mm@kvack.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok if the crypto request_module is changed it makes more sense to
change zpool's use of request_module; it looks like there are a couple
other places in the kernel using prefixes/aliases (although it's not
universal).  I still suggest moving the MODULE_ALIAS() into
zbud/zsmalloc's #ifdef CONFIG_ZPOOL, though.


On Fri, Aug 8, 2014 at 11:08 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Aug 08, 2014 at 05:06:41PM -0700, Kees Cook wrote:
>>
>> I think we need to fix zswap now before it gets too far, and likely
>> adjust the crypto API to use a module prefix as well. Perhaps we need
>> a "crypto-" prefix?
>
> Yes I think a crypto- prefix would make sense.  Most crypto
> algorithms should be providing an alias already so it's mostly
> just changing the aliases.
>
> Patches are welcome :)
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
