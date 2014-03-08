Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaCHKLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 05:11:21 -0500
Received: from mailscanner02.zoner.fi ([84.34.166.11]:44244 "EHLO
	mailscanner02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaCHKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 05:11:17 -0500
Date: Sat, 8 Mar 2014 12:11:06 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Kyle McMartin <kyle@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
Message-ID: <20140308121106.2ff89ab0@tukaani.org>
In-Reply-To: <CAMuHMdXJ+GKtbCr-fzq2tRf8yUeYmgSA2VpmL2aofybc84Wwog@mail.gmail.com>
References: <20140228230017.GE14970@merlin.infradead.org>
	<20140303145137.70819698@tukaani.org>
	<CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com>
	<20140304202038.03b36109@tukaani.org>
	<53169123.4020909@lougher.demon.co.uk>
	<CAGVrzcYQ44fYA0kpRC84Qfe7v0vPGy+euWLfs8xF0XEMnsFmGA@mail.gmail.com>
	<CAMuHMdXJ+GKtbCr-fzq2tRf8yUeYmgSA2VpmL2aofybc84Wwog@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-06 Geert Uytterhoeven wrote:
> I once tried xz with an initrd on ARM. The kernel complained it
> couldn't decompress the initrd, oops. I didn't investigate it at that
> time, but probably I didn't have the x86 BCJ filter enabled, while I
> compressed the initrd on\ amd64.

With so little information I can only guess, but it sounds unlikely
that you would have enabled the x86 BCJ filter without knowing it
unless you used some wrapper script that does it. It's more likely that
the ARM kernel didn't support XZ at all, you forgot --check=crc32,
or it ran out of RAM due to too big LZMA2 dictionary (if you used -9,
the decompressor allocates 64 MiB of memory, but I cannot guess how
much RAM the target system had).

In Documentation/xz.txt under "Notes on compression options" there are
some tips about compressing files for the in-kernel XZ decompressor.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
