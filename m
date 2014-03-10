Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaCJUTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:19:19 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:42994 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaCJUTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <531E1B53.5090205@linux.intel.com>
References: <20140307013833.GD8427@localhost>
	<1394176888.1018.3.camel@wall-e.seibold.net>
	<CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
	<1394229220.20013.13.camel@wall-e.seibold.net>
	<CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
	<1394354848.1002.37.camel@wall-e.seibold.net>
	<531D044C.2090303@linux.intel.com>
	<CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
	<CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
	<531DD35A.5060202@linux.intel.com>
	<CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
	<CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
	<1394481804.980.9.camel@wall-e.seibold.net>
	<531E1B53.5090205@linux.intel.com>
Date: Mon, 10 Mar 2014 13:19:17 -0700
X-Google-Sender-Auth: lTG3hVak8atC7zja4i8W8LoKu3E
Message-ID: <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 1:06 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> The quick way to get something working is simply to reserve more than
> one page (two should presumably be enough) in the fixmap and adjust the
> link address of the VDSO accordingly.  This is not where we want to go
> in the long term, but it doesn't seem to make sense to try to do
> everything all at once -- we are already starting to push way too close
> to the 3.15 merge window.

If the only immediate problem is the code generation size, then Andy
already had a (simpler) hack-around:

  #undef CONFIG_OPTIMIZE_INLINING
  #undef CONFIG_X86_PPRO_FENCE

in vclock_gettime.c.

I think we could make it a bit less hacky by just restricting the
inlining of the paravirt case, since that's presumably the crap code
that causes things to grow too large. Or find out what in there it is
that explodes in size, and just try to de-crapify the code enough that
it no longer does that.

Or is there something else going on too?

           Linus
