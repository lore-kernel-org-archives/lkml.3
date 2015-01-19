Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbbASKEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:04:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:54807 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbbASKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:04:46 -0500
Date: Mon, 19 Jan 2015 11:04:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jsrhbz@kanargh.force9.co.uk, christoph.muellner@theobroma-systems.com,
        linux@roeck-us.net, linux@rasmusvillemoes.dk,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, mingo@kernel.org,
        akpm@linux-foundation.org, hpa@zytor.com, maxime.coquelin@st.com,
        linux-kernel@vger.kernel.org, martink@posteo.de, tytso@mit.edu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/types] bitops: Add sign_extend8(), 16 and 64 functions
Message-ID: <20150119100439.GN25256@twins.programming.kicks-ass.net>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
 <tip-7e9358073d3f0ed0a028c48aa54009b3296dffc9@git.kernel.org>
 <CA+55aFyc7TbnLBi3rcQDrtkwg9TgDnb5dAfupMGSbTKZC6Xd0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyc7TbnLBi3rcQDrtkwg9TgDnb5dAfupMGSbTKZC6Xd0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 07:54:22AM +1200, Linus Torvalds wrote:
> Why?
> 
> The 8- and 16- bit versions are the same as the 32-bit one. This seems
> pointless. If you want something where the sign is in bit 3, they all
> return the same value, just the return type differs, but that's really a
> *caller* thing, no?

Even for the 8bit ones? Since we have the *H and *L register we have
more 8 bit regs than we have 16/32 bit regs and it might just be worth
it.

Since these are inlines the whole calling convention which would clobber
the whole of eax can go away.

Now granted, this is all very tenuous at best. A more convincing
argument might be that of documentation; calling sign_extend32() on
something you know to be a byte might be less intuitive.

