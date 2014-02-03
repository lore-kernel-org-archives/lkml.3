Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBCQhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:37:48 -0500
Received: from imap.thunk.org ([74.207.234.97]:53799 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaBCQhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:37:46 -0500
Date: Mon, 3 Feb 2014 11:37:29 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140203163729.GA13634@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
	blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
	geert@linux-m68k.org, tg@mirbsd.de
References: <20140202203617.GA9499@logfs.org>
 <20140203155042.GD9499@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140203155042.GD9499@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:50:42AM -0500, Jörn Engel wrote:
> If the measurement event is an interrupt and the CPU has a
> cycle-counter, you are set.  On interesting systems lacking a
> cycle-counter, we still have a high-resolution counter or sorts that
> is the CPU itself.
> 
> Instruction pointer and stack pointer for both kernel and userland are
> one way to read out the "counter".  Main problem here are tight loops
> where your "counter" is not high-resolution at all.  But something
> within the CPU is constantly changing.  And that something tends to be
> contained in the registers.
> 
> How about taking the saved registers from the interrupted CPU, xor'ing
> them all and calling the result random_get_entropy() on systems
> lacking a good cycles-counter?

So we could take the struct pt_regs which we get from get_irq_regs(),
XOR them together and use them to feed into input[2] amd input[3] in
add_interrupt_randomness().  Or some other way of distributing the
values of all of the irq registers into the __u32 input[4] array.

That would probably be a good and useful thing to do.  Was that
basically what you were suggesting?

						- Ted
