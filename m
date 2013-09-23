Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3IWA1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 20:27:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab3IWA1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 20:27:32 -0400
Message-ID: <523F8AA6.7040406@zytor.com>
Date: Sun, 22 Sep 2013 17:26:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH, RFC 10/12] random: cap the rate which the /dev/urandom
 pool gets reseeded
References: <1379882338-7209-1-git-send-email-tytso@mit.edu> <1379882338-7209-11-git-send-email-tytso@mit.edu> <e665f20c-9154-4dbd-bb93-cf144922bf29@email.android.com> <20130922214039.GC7321@thunk.org> <a3890544-745e-462d-8647-68c5abf78e9e@email.android.com> <20130922232337.GD7321@thunk.org>
In-Reply-To: <20130922232337.GD7321@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 04:23 PM, Theodore Ts'o wrote:
> On Sun, Sep 22, 2013 at 03:45:11PM -0700, H. Peter Anvin wrote:
>> I understand the motivation, but I question basing it in a fixed amount of time.
> 
> We already have a threshold based on the amount of the entropy in the
> input pool.  I could increase that threshold, but then instead of
> having the entropy hover between say, 192 and 128, it would hover
> between say, 576 and 512.  What that means in practice is that there
> will be a higher baseline, but we will still end up reseeding every 10
> seconds or so (that being approximately how much entropy I've seen
> flowing into the input pool on my laptop system --- 64 bits every 10
> seconds or so).
> 
> By basing it on a time-based threshold, it means that the input pool
> can build up faster such that over time, such that entropy pool ends
> up hovering around 3400 bits.
> 

So make it a threshold around 2048-3072 bits.  A.k.a. "if the input pool
is filling up fast enough, take advantage of it."

> What is your concern is about having it being time-based --- or more
> accurately, being partially time-based, since we also keep the entorpy
> count based threshold?  I'll note that the Fortuna Random Number
> Generator, devised by Bruce Schneier and Niels Ferguson also uses as
> part of its design a time-based reseed limit.

Just that it is unnecessary in a scenario when entropy is plentiful.

	-hpa


