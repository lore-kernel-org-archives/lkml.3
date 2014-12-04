Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbaLDQhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:37:15 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58171 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932288AbaLDQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:37:13 -0500
X-Sasl-enc: 3P5W+yZzkeaWybEvy5Z0i/y9LylZUgXdxgBOgH4V3Qkk 1417711032
Message-ID: <1417711030.5386.35.camel@localhost>
Subject: Re: [PATCH net-next] arch_fast_hash: avoid indirect function calls
 and implement hash in asm
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>,
        Thomas Graf <tgraf@suug.ch>, Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2014 17:37:10 +0100
In-Reply-To: <20141204155610.GA22340@gondor.apana.org.au>
References: <e77237174e1b8d743ef5171e05abde82bc54af37.1417696901.git.hannes@stressinduktion.org>
	 <20141204155610.GA22340@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 2014-12-04 at 23:56 +0800, Herbert Xu wrote:
> On Thu, Dec 04, 2014 at 02:08:50PM +0100, Hannes Frederic Sowa wrote:
> > By default the arch_fast_hash hashing function pointers are initialized
> > to jhash(2). If during boot-up a CPU with SSE4.2 is detected they get
> > updated to the CRC32 ones. This dispatching scheme incurs a function
> > pointer lookup and indirect call for every hashing operation.
> 
> Just curious, is jhash actually faster than generic C CRC32 on
> common platforms?

Yes, jhash always beats crc32 in software on x86_64 and ia32.

Bye,
Hannes


