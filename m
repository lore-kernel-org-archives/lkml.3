Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3J1QQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:16:07 -0400
Received: from mail.eperm.de ([89.247.134.16]:56633 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab3J1QQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:16:05 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Theodore Ts'o" <tytso@mit.edu>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 28 Oct 2013 17:15:38 +0100
Message-ID: <1433673.JyzufUuaAG@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131028160623.GD15440@khazad-dum.debian.net>
References: <2579337.FPgJGgHYdz@tauon> <2049321.gMV6JUDze7@tauon> <20131028160623.GD15440@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. Oktober 2013, 14:06:23 schrieb Henrique de Moraes 
Holschuh:

Hi Henrique,

>On Mon, 28 Oct 2013, Stephan Mueller wrote:
>> If it is accepted that the CPU Jitter RNG delivers entropy, the
>> latter
>> update may now allow us to get rid of storing the seed file during
>> shutdown and restoring it during the next boot sequence.
>
>That's a 4096-bit safety net (uncredited entropy) which at least Debian
>shall not remove.

That is correct, and I did not want have such safety net removed.

I have to correct my initial statement: there is a possibility where the 
CPU Jitter RNG may not deliver data: when the timer resolution is too 
coarse. Thus, please disregard my notion to remove the user space 
seeding.

My goal is that the entropy pools are filled with entropy at the time 
when they are created so that they will deliver good random data if the 
system has a high resolution timer (which is almost always the case as 
shown with my tests).

>
>I think Debian also dumps some low-entropy-per-bit crap into
>/dev/random during boot (again, not credited), such as the boot kernel
>logs.  We could increase the density of that entropy a lot using gzip
>-0 or something like that... is an uncredited low-entropy-per-bit dump
>into the pool detrimental to its quality?

Any mixing of data into the entropy pools can never diminish the 
entropy, but just further mix the data.

Note, a simple write of data into the device files will never update the 
entropy estimator that is behind the blocking of /dev/random. All that 
is done by the write to the device files is the mixing of the entropy 
pools of blocking_pool and nonblocking_pool (and not input_pool).

Ciao
Stephan
