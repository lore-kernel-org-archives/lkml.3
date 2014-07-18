Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbaGRUGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:06:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43341 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbaGRUGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:06:14 -0400
Message-ID: <53C97E0F.6090601@zytor.com>
Date: Fri, 18 Jul 2014 13:05:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20140718150005.73db8eb9@canb.auug.org.au> <53C97287.5020509@zytor.com> <CALCETrXs4fdKDA1C4ts3qzgbB6PrmCZZyK3R4cBLaO9RbBp0YA@mail.gmail.com>
In-Reply-To: <CALCETrXs4fdKDA1C4ts3qzgbB6PrmCZZyK3R4cBLaO9RbBp0YA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 12:57 PM, Andy Lutomirski wrote:
> 
> This particular warning is IMO in a particularly dumb category: GCC
> optimizes some code and then warns about a construct that wasn't there
> in the original code.  In this case, I think it unrolled a loop and
> discovered that one iteration contained a test that was always true.
> Big deal.
> 
> (OTOH, the code in question was buggy, but not all for the reason that
> GCC thought it was.)
> 

		if (syms[sym_vvar_start] > syms[i] + 4096)
			fail("%s underruns begin_vvar\n",
			     required_syms[i].name);

if i == sym_vvar_start then this is at least a valid warning.  It could
easily be quieted by chaning syms[] to an unsigned array.

	-hpa

