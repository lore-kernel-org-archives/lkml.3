Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaCKV0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:26:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60567 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaCKV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:26:13 -0400
Date: Tue, 11 Mar 2014 21:25:44 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: On trying to drop X86_PPRO_FENCE..
Message-ID: <20140311212544.27071674@alan.etchedpixels.co.uk>
In-Reply-To: <CA+55aFw_1Cw1hWVLB7HG_2SKW=7NXH8=DR3a96q4fqOhoOcdpQ@mail.gmail.com>
References: <CA+55aFw_1Cw1hWVLB7HG_2SKW=7NXH8=DR3a96q4fqOhoOcdpQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (Although honestly, that whole thing is so long ago that my "dim
> memory" is very suspect, and it's possible the workaround actually
> came independently of that from Alan Cox. This all happened in
> v2.4.13-rc2 - late 2001 - and the PPro workaround came in together
> with the X86 OOSTORE code, which I *think* was Alan. Asking the gnomes
> in case they remember how it happened).

Because people were actually managing to hit both that and the "funny
area of broken memory" bug on the PPro. I think (but may be wrong) it was
an ALR 6 way that showed up the locking bug. The usual case you hit the
fencing errata on the PPro was MMIO writes to graphics cards. Several
drivers (notably the 3Dfx drivers) had special fencing workarounds for it.

OOSTORE was for the IDT WinChip which was an unrelated x86 processor
which had an interesting ability to run with slacker cache coherency. It
was a very simple minded CPU so wasn't good at speculation so you could
get *big* performance gains by putting it in out of order store mode.

It just happened that the feature and erratum looked similar so got dealt
with in the same basic way.

It's worth reading some of the other errata documents, fencing errata of
various kinds pop up in a wide range of x86 processors. It's up there
with "rep movs" for 'wtf' behaviour 8)

Alan
