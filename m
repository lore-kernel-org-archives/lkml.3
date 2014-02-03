Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaBCWBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:01:23 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:53052 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaBCWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:01:22 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 17:01:22 EST
Date: Mon, 3 Feb 2014 21:54:22 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Theodore Ts'o" <tytso@mit.edu>
cc: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        Geert Uytterhoeven <geert@linux-m68k.org>, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
In-Reply-To: <20140203163729.GA13634@thunk.org>
Message-ID: <alpine.LFD.2.10.1402032149530.3940@eddie.linux-mips.org>
References: <20140202203617.GA9499@logfs.org> <20140203155042.GD9499@logfs.org> <20140203163729.GA13634@thunk.org>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Theodore Ts'o wrote:

> > How about taking the saved registers from the interrupted CPU, xor'ing
> > them all and calling the result random_get_entropy() on systems
> > lacking a good cycles-counter?
> 
> So we could take the struct pt_regs which we get from get_irq_regs(),
> XOR them together and use them to feed into input[2] amd input[3] in
> add_interrupt_randomness().  Or some other way of distributing the
> values of all of the irq registers into the __u32 input[4] array.

 Can we be sure we don't leak information this way?  Just being 
paranoid...

  Maciej
