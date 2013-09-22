Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3IVWqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:46:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37080 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab3IVWqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:46:05 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130922214039.GC7321@thunk.org>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu> <1379882338-7209-11-git-send-email-tytso@mit.edu> <e665f20c-9154-4dbd-bb93-cf144922bf29@email.android.com> <20130922214039.GC7321@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH, RFC 10/12] random: cap the rate which the /dev/urandom pool gets reseeded
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 22 Sep 2013 15:45:11 -0700
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
Message-ID: <a3890544-745e-462d-8647-68c5abf78e9e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understand the motivation, but I question basing it in a fixed amount of time.

Theodore Ts'o <tytso@mit.edu> wrote:
>On Sun, Sep 22, 2013 at 02:21:48PM -0700, H. Peter Anvin wrote:
>> Is this really an improvement on a system with plenty of entropy?
>Would it not make more sense to modulate this bad on entropy production
>rates?
>> 
>> Also, the urandom pool is only reseeded once per read, no matter how
>large...
>
>I added this after observing using the random driver's tracepoints to
>measure how the entropy pool behaves on a desktop system.  It turns
>outs the Chrome browser requests a truly amazing amount of entropy
>using /dev/urandom.  Enough so that while you are reading GMail or
>using G+, the available entropy in the input pool is always running at
>minimum levels.  (i.e., it never gets above 192 bits before we do a
>catatrophic reseed and it drops down to 128 bits.)
>
>I'm not sure what the heck it is doing --- maybe it is using
>/dev/urandom to generate random padding values?  I can't believe it is
>opening new SSL connetions that quickly.  So this might be a Chrome
>bug, and I can talk to some Chrome developers when I get into work
>tomorrow.  But in the case of badly behaved applications, this is
>useful.
>
>It results in more entropy building up in the input pool before we do
>a reseed, so it should result in better "catastrophic reseeding", and
>it means that there is more entropy available in the input pool for
>use by the /dev/random pool, even if /dev/urandom is being used in
>what might be arguably considered an abusive fashion.
>
>You can test this by applying the patch, and observing the value of
>/proc/sys/kernel/random/entropy_avail over time while running a Chrome
>browser (and there may be other userspace applications which are as
>aggressive in the use of /dev/urandom).  The compare it after running
>the command "echo 0 > /proc/sys/kernel/random/urandom_min_reseed_secs",
>which will restore the original pre-patch behaviour.
>
>						- Ted

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
