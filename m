Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaDYMCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:02:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaDYMCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:02:32 -0400
Date: Fri, 25 Apr 2014 14:02:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <amluto@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140425120229.GA4691@amd.pavel.ucw.cz>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is a prototype of espfix for the 64-bit kernel.  espfix is a
> workaround for the architectural definition of IRET, which fails to
> restore bits [31:16] of %esp when returning to a 16-bit stack
> segment.  We have a workaround for the 32-bit kernel, but that
> implementation doesn't work for 64 bits.

Just to understand the consequences -- we leak 16 bit of kernel data
to the userspace, right? Because it is %esp, we know that we leak
stack address, which is not too sensitive, but will make kernel
address randomization less useful...?

> The 64-bit implementation works like this:
> 
> Set up a ministack for each CPU, which is then mapped 65536 times
> using the page tables.  This implementation uses the second-to-last
> PGD slot for this; with a 64-byte espfix stack this is sufficient for
> 2^18 CPUs (currently we support a max of 2^13 CPUs.)

16-bit stack segments on 64-bit machine. Who still uses it? Dosemu?
Wine? Would the solution be to disallow that?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
