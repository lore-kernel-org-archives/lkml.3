Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3ETOh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:37:29 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43777 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756591Ab3ETOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:37:27 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against spraying attacks
Date: Mon, 20 May 2013 15:35:58 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B723F@saturn3.aculab.com>
In-Reply-To: <1369059993.3301.174.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against spraying attacks
Thread-Index: Ac5VZeNI+608K/gQQ1aHymv06Dfl4AAAM6ig
References: <1368844623.3301.142.camel@edumazet-glaptop> <20130520141941.GA16412@breakpoint.cc> <1369059993.3301.174.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>, "Florian Westphal" <fw@strlen.de>
Cc: "David Miller" <davem@davemloft.net>, "netdev" <netdev@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4KEbYfU013203

> > What about emitting additional instructions at random locations in the
> > generated code itself?
> >
> > Eg., after every instruction, have random chance to insert
> > 'xor $0xcc,%al; xor $0xcc,%al', etc?
> 
> This will be the latest thing I'll do.
> 
> Frankly, whole point of BPF JIT is speed.
> 
> If we have slow code, just use the interpretor instead.

Adding one of the standard nop opcodes wouldn't be too bad.
IIRC 0x90 is skipped very early on by modern cpu.
Adding one after every nth (or n-mth) instruction would
probably break the alternate instruction stream.

However the attacker could (probably) keep installing
code patterns until the guess pattern matched.

Also the code size changes might make the JIT compile fail
- maybe because of branch offsets, or just size.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
