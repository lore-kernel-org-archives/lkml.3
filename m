Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3A2OMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:12:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43834 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab3A2OMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:12:05 -0500
Date: Tue, 29 Jan 2013 15:12:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 16/20] scripts/gdb: Add internal helper and
 convenience function for per-cpu lookup
Message-ID: <20130129141202.GH14302@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Andi Kleen <andi@firstfloor.org>, Tom Tromey <tromey@redhat.com>,
	Ben Widawsky <ben@bwidawsk.net>,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
References: <cover.1359463075.git.jan.kiszka@siemens.com>
 <04960fa208fbd9c0962eb4f70aa45d28aec59e8d.1359463075.git.jan.kiszka@siemens.com>
 <20130129135109.GF14302@pd.tnic>
 <5107D528.2010305@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5107D528.2010305@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 02:56:56PM +0100, Jan Kiszka wrote:
> Let me guess: You are dumping a weird QEMU/KVM CPU, right?

Nah, I actually have the silicon! :-)

Joking, of course. I wish. I'm booting the guest with -cpu phenom (it
has been like that since forever in my boot-kernel-in-kvm script) but
the host is Intel.

If I do this on an AMD host, all is ok:

(gdb) p $lx_per_cpu("cpu_info").x86_vendor_id
$1 = "AuthenticAMD\000\000\000"
(gdb) p $lx_per_cpu("cpu_info").x86_model_id
$2 = "AMD Phenom(tm) 9550 Quad-Core Processor", '\000' <repeats 24 times>
(gdb)

[ … ]

> >> +class PerCpu(gdb.Function):
> >> +	__doc__ = "Return per-cpu variable.\n" \
> >> +		  "\n" \
> >> +		  "$lx_per_cpu(\"VAR\"[, CPU]): Return the per-cpu variable called VAR for the\n" \
> >> +		  "given CPU number. If CPU is omitted, the CPU of the current context is used.\n" \
> >> +		  "Note that VAR has to be quoted as string."
> > 
> > 
> > Ok, seriously now:
> > 
> > apropos shows the "Return per-cpu... " line above. Have you found out
> > which gdb command shows the rest? help and info both say "Undefined
> > command".
> 
> help function lx_...
> 
> It took me a while to find this, too.

Maybe worth documenting it then at the end of gdb-kernel-debugging.txt?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
