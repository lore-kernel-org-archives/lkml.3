Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3CWRQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:16:30 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:52442 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3CWRQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:16:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130323155256.GB10811@pd.tnic>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
	<1364001923-10796-13-git-send-email-andi@firstfloor.org>
	<20130323115115.GA10821@pd.tnic>
	<20130323135156.GJ20853@two.firstfloor.org>
	<20130323155256.GB10811@pd.tnic>
Date: Sat, 23 Mar 2013 10:16:28 -0700
X-Google-Sender-Auth: QDNwwnlTRr9On54X772tj9-sQ8I
Message-ID: <CA+55aFwim=_UjV+n6MGRCgoa3B-9RuhVF2h=munaRpZhT3Ntfg@mail.gmail.com>
Subject: Re: [PATCH 12/29] x86, tsx: Add a per thread transaction disable count
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 8:52 AM, Borislav Petkov <bp@alien8.de> wrote:
>
> Really? Let's see:

Your test seems to assume that a single bit is sufficient, which
sounds unlikely. If you have any kind of nesting going on, you need
more than one bit. Then add/sub isn't a single "xor" of a bit any
more.

That said, making it just a byte sounds more than enough. How deep
would anybody want to nest it? Do we care?

                   Linus
