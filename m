Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3ETNe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:34:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35966 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab3ETNey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:34:54 -0400
Message-ID: <1369056893.3301.160.camel@edumazet-glaptop>
Subject: RE: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against
 spraying attacks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date: Mon, 20 May 2013 06:34:53 -0700
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B723E@saturn3.aculab.com>
References: <1368844623.3301.142.camel@edumazet-glaptop>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B723E@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 09:51 +0100, David Laight wrote:

> Hmmm.... anyone looking to overwrite kernel code will then start
> looking for blocks of 0xcc bytes and know that what follows
> is the beginning of a function.
> That isn't any harder than random writes.
> 
> Copying a random part of .rodata might be better - especially
> if you can find part of .rodata.str*.

That's not the point. We want to catch jumps to before/after the code.

An attacker having full access to kernel code in read and write mode has
full power anyway to do whatever he wants.


