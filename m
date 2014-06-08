Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaFHU0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:26:45 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44676 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbaFHU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:26:37 -0400
Message-Id: <1402259195.15111.126514097.12D848DB@webmail.messagingengine.com>
X-Sasl-Enc: ne9kJyecRPZys2Pf0OY4TPcK8xRxnAMaL2QffRVKnoux 1402259195
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>, dborkman@redhat.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, shemminger@osdl.org,
        tytso@mit.edu
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-037d6a32
In-Reply-To: <20140608124031.2571.qmail@ns.horizon.com>
References: <20140608124031.2571.qmail@ns.horizon.com>
Subject: Re: [PATCH 4/7] lib/random32.c: Use <asm/unaligned.h> instead of
 hand-rolling it
Date: Sun, 08 Jun 2014 13:26:35 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014, at 5:40, George Spelvin wrote:
> > Seems fine by me, since it's random anyway archs might not care
> > about the *_le32, though this might yield additional work in some
> > cases I presume.
> 
> If you think that's okay, sure.  I kept it consistent to get byte-for-byte
> identical results.
> 
> If variations in that are allowed, that can also
> simplify the trailing storage case:
> 
> +		if (bytes & 2)
> +			put_unaligned_le16((u16)random, p+i);
> +		if (bytes & 1)
> +			p[i+bytes-1] = (u8)(random >> 16);

Yes, please! Otherwise the code looks much too complicated for what it does.

> > Nit: '(u8) random'
> 
> Actually, my style and most of the kerel is to not put
> a space in a cast, since it binds so tighty.
> 
> E.g. compare
> 
> git grep ')[a-z]' kernel/
> git grep ') [a-z]' kernel/
> 
> Notice that the second is alsmost all comments.
> (There are some spaces in kernel/ptrace.v.)
> 
> I'd rather leave it without the space unless you feel
> very strongly about it.

IMHO I wouldn't put a whitespace here.

Bye,
Hannes
