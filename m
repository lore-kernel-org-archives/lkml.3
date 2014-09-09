Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaIIIMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:12:22 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56748 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaIIIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:12:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Hurley <peter@hurleysoftware.com>, paulmck@linux.vnet.ibm.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jakub Jelinek <jakub@redhat.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
Date: Tue, 09 Sep 2014 10:11:39 +0200
Message-ID: <2998968.X0xyWHN7fU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540E6582.9020403@zytor.com>
References: <21512.10628.412205.873477@gargle.gargle.HOWL> <1410216228.2027.88.camel@jarvis.lan> <540E6582.9020403@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:63eX6JjBGdTx5Jn7cCKyAsDhAbqb1moO6+7blcw+qDA
 ZeFLXC5F5wP07s6dGuo5WGSzRR8Cp7V8pBmmKlshuy7yQJRedb
 fvOvL2diJpsXAPhSGzhJOJs4PTiN2gWi1aTO26GZs2WBwOLhWn
 U49egK5GtHHntO1cGb5wGTu/HKH7mehFTKAjb7749/R28+3IMV
 XRkfpUDaSxaUgQEMShfq+mby7BJ9nUavptYqC7iu0Kkn3wRQcw
 qZkTsxD2OE40bzDnnHuqRn3i2rbiooqSgqyjPjhcZ1xpE2yy29
 0NUPQ0Q6asnge3C0a3Ngv4M3BhVZEIXkX4A9awH7J7OVDTEOpz
 pijSuGTI+i42kXYKwa8E=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2014 19:27:14 H. Peter Anvin wrote:
> On 09/08/2014 03:43 PM, James Bottomley wrote:
> > 
> > This was years ago (possibly decades).  We had to implement in-kernel
> > unaligned traps for the networking layer because it could access short
> > and int fields that weren't of the correct alignment when processing
> > packets.  It that's all corrected now, we wouldn't really notice (except
> > a bit of a speed up since an unaligned trap effectively places the
> > broken out instructions into the bit stream).

I believe the current line of thinking is to consider it a bug in
the device driver. Those bugs may still exist in some rare legacy
drivers, but anything you'd see in practice should not require unaligned
access any more.

> Well, ARM doesn't trap, it just silently gives garbage on unaligned
> memory references.

ARMv6/v7 (anything that really matters these days) has efficient unaligned
accesses that work. Older CPUs are normally set to trap on unaligned
access, originally for the reason James mentions above, but there are
some even older machines that rely on abusing unaligned accesses to do
byte swapping.

	Arnd
