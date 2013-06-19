Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab3FSSwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:52:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807Ab3FSSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:52:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 3/5] tty/8250_dw: Add support for OCTEON UARTS.
Date: Wed, 19 Jun 2013 20:52:09 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, Jamie Iles <jamie@jamieiles.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com> <2302882.NVjP8DdXWY@wuerfel> <51C1E028.2040700@caviumnetworks.com>
In-Reply-To: <51C1E028.2040700@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306192052.09575.arnd@arndb.de>
X-Provags-ID: V02:K0:ZbYxcUpUyS76u1/rRQTN2kLUR9D28x30SfPTuHYQJER
 WAFUaIwoHq3z+luwzRdlpp7McZt5/snat/+Nntz4UUqTlUBT8F
 ovyG2KZm46NCfQeflT6Bq8fFCtUafbK/VOf8SeApbhTeOIgkBK
 lb7gyNWg20jZSqA06ji8eXWzRPhRDbCqyEXq+npMqI6MfmJy4H
 9vHmMBFpFQPQDQBGEob+y9wwQQE98q8m3NbiXXVkrZFVJGszWk
 ARX7qQt8QV8Ido5qrlh5Na+Pxi9SaJnrLWM8hj4WsVh5VCTF8s
 WnwtkBPBtxQ+TREcDmn1fKVk6wqabG2T7MNRxHyFmoVg8XdLhw
 dXINtU6n9qW41CcX9DQk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, David Daney wrote:
> On 06/19/2013 03:01 AM, Arnd Bergmann wrote:

> > It's also wrong to use the
> > __raw_* variant, which is not guaranteed to be atomic and is not
> > endian-safe.
> 
> We do runtime probing and only use this function on platforms where it 
> is appropriate, so atomicity is not an issue.  As for endianess, I used 
> the __raw_ variant precisely because it is correct for both big and 
> little endian kernels.

You don't know what the compiler turns a __raw_writeq into, it could
always to eight byte wise stores, that's why typically writeq is
an inline assembly while __raw_writeq is just a pointer dereference.

__raw_* never do endian swaps, so it will be wrong on either big-endian
CPUs or on little-endian CPUs, depending on what the MMIO register
needs.

	Arnd
