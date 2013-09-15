Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3IOLM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 07:12:26 -0400
Received: from mail.eperm.de ([89.247.134.16]:56906 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab3IOLMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 07:12:24 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Sun, 15 Sep 2013 13:12:15 +0200
Message-ID: <3242570.OlG8jyNm4p@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130913185931.GB15366@thunk.org>
References: <10005394.BRCyBMYWy3@tauon> <1974157.PE35U8AyTG@tauon> <20130913185931.GB15366@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 13. September 2013, 14:59:31 schrieb Theodore Ts'o:

Hi Theodore,

>On Fri, Sep 13, 2013 at 07:36:20AM +0200, Stephan Mueller wrote:
>
>However, if you are worried about a malicious entropy source, things
>are a little bit different.  Suppose RDRAND == AES(i++, NSA_KEY),
>where the NSA doesn't know the starting value of i.  But if it get can
>get a raw RDRAND value (say, someone uses it without doing any
>whitening as a session key or as a D-H parameter), it can decrypt the
>output using the NSA_KEY, and then now that it knows i, it can brute
>force break the RDRAND output, even if it's not entirely sure how many
>times RDRAND has been called between that cleanb RDRAND value and the
>RDRAND output it is trying to break.
>
>In *this* case, smearing out the value of RDRAND across the entropy
>pool does help, becuase it makes it significantly harder to get a
>clean RDRAND value to decrypt.

Agreed. I was only talking about "well-behaved" entropy sources.
>
>
>That being said, the much bigger problem that I'm worried about is not
>necessarily a trojan'ed RDRAND, but rather on embedded ARM and MIPS
>devices where we have unsufficient entropy, and on the first boot out
>of the box, there is no random seed file that can be fixed in at boot

Yes, my local MIPS-based router which is a very ubiquitous one in 
Germany (Fritz Box) does not seed /dev/random but yet starts using 
/dev/urandom during boot cycle.

>time.  Mixing in personalization information (serial numbers, MAC
>addresses) which *hopefully* the NSA wouldn't know in the case of
>pervasive, bulk surveillance, is a bit of a help.  But it's certainly
>no help against a direct, targetted attack.

That is why I am hoping that the CPU jitter as harvested by my RNG will 
help as it delivers entropy on demand in a bandwidth where the initial 
seeding may not needed any more and we have sufficient entropy during 
boot sequence.
>
>Regards,
>
>						- Ted


Ciao
Stephan
