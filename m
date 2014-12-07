Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaLGNOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:14:46 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56191 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbaLGNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:14:43 -0500
X-Sasl-enc: +obBh3Vwa3DeZWBiQmgCTHvql89L5VjSocRIIYxM0phu 1417958082
Message-ID: <1417958080.17658.32.camel@localhost>
Subject: Re: Where exactly will arch_fast_hash be used
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, dborkman@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch
Date: Sun, 07 Dec 2014 14:14:40 +0100
In-Reply-To: <20141207052041.20498.qmail@ns.horizon.com>
References: <20141207052041.20498.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On So, 2014-12-07 at 00:20 -0500, George Spelvin wrote:
> If you want DoS-resistant hash tables, I'm working on adding SipHash
> to the kernel.
> 
> This is a keyed pseudo-random function designed specifically for that
> application.  I am starting with ext4 directory hashes, and then intended
> to expand to secure sequence numbers (since it's far faster than MD5).

Please consider xfs, too.
AFAIK xfs doesn't seed their hashing so far and the hashing function is
pretty weak. One example:
http://marc.info/?l=linux-xfs&m=139590613002926&w=2

> (I'm trying to figure out a good interface, since the crypto API
> is a bit heavy for something to heavily optimized.)

Ack. If we want to use it in the networking stack we should be able to
use it without a dependency to the crypto framework.

Bye,
Hannes


