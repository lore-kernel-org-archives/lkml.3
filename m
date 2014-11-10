Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaKJR4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:56:38 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34673 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaKJR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:56:36 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 10 Nov 2014 09:56:28 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: Re: linux-next: manual merge of the tiny tree with the net-next tree
Message-ID: <20141110175628.GB18766@thin>
References: <20141110142511.03354f6a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110142511.03354f6a@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 02:25:11PM +1100, Stephen Rothwell wrote:
> Hi Josh,
> 
> Today's linux-next merge of the tiny tree got a conflict in
> lib/Makefile between commit e5a2c8999576 ("fast_hash: avoid indirect
> function calls") from the net-next tree and commit 4ecea0db79ef ("lib:
> rhashtable: Make rhashtable.c optional") from the tiny tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This resolution looks correct to me.

- Josh Triplett

> diff --cc lib/Makefile
> index 04e53dd16070,47b8305288e2..000000000000
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@@ -22,11 -22,14 +22,14 @@@ lib-$(CONFIG_SMP) += cpumask.
>   lib-y	+= kobject.o klist.o
>   obj-y	+= lockref.o
>   
> - obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
> + obj-y += bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
>   	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> - 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
> + 	 gcd.o lcm.o list_sort.o uuid.o iovec.o clz_ctz.o \
>   	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
> - 	 percpu-refcount.o percpu_ida.o rhashtable.o
>  -	 percpu-refcount.o percpu_ida.o hash.o
> ++	 percpu-refcount.o percpu_ida.o
> + obj-$(CONFIG_FLEX_ARRAY) += flex_array.o
> + obj-$(CONFIG_HALFMD4) += halfmd4.o
> + obj-$(CONFIG_RHASHTABLE) += rhashtable.o
>   obj-y += string_helpers.o
>   obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
>   obj-y += kstrtox.o


