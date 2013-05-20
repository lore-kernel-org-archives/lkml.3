Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab3ETJDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:03:19 -0400
Received: from mx0.aculab.com ([213.249.233.131]:38669 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751139Ab3ETJDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:03:17 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against spraying attacks
Date: Mon, 20 May 2013 09:51:59 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B723E@saturn3.aculab.com>
In-Reply-To: <1368844623.3301.142.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against spraying attacks
Thread-Index: Ac5TcHIh5J54lOyxRzS7a/3lTwWoQABxcg5g
References: <1368844623.3301.142.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David Miller" <davem@davemloft.net>
Cc: "netdev" <netdev@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4K93R3J010652

> hpa bringed into my attention some security related issues
> with BPF JIT on x86.
> 
> This patch makes sure the bpf generated code is marked read only,
> as other kernel text sections.
> 
> It also splits the unused space (we vmalloc() and only use a fraction of
> the page) in two parts, so that the generated bpf code not starts at a
> known offset in the page, but a pseudo random one.
...
> +static struct bpf_binary_header *bpf_alloc_binary(unsigned int proglen,
> +						  u8 **image_ptr)
...
> +	/* insert a random number of int3 instructions before BPF code */
> +	*image_ptr = &header->image[prandom_u32() % hole];
> +	return header;
> +}

Hmmm.... anyone looking to overwrite kernel code will then start
looking for blocks of 0xcc bytes and know that what follows
is the beginning of a function.
That isn't any harder than random writes.

Copying a random part of .rodata might be better - especially
if you can find part of .rodata.str*.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
