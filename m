Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaFXKvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:51:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39079 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbaFXKvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:51:12 -0400
Date: Tue, 24 Jun 2014 12:51:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, security@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
        stable@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86_32,entry: Do syscall exit work on badsys
 (CVE-2014-4508)
Message-ID: <20140624105108.GG4439@pd.tnic>
References: <CA+5PVA70nFS8JZkL0-Q-1HjFHT5NA04275_M4WstjQMrpT+hrQ@mail.gmail.com>
 <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:22:15PM -0700, Andy Lutomirski wrote:
> The bad syscall nr paths are their own incomprehensible route
> through the entry control flow.  Rearrange them to work just like
> syscalls that return -ENOSYS.
> 
> This fixes an OOPS in the audit code when fast-path auditing is
> enabled and sysenter gets a bad syscall nr (CVE-2014-4508).
> 
> This has probably been broken since Linux 2.6.27:
> af0575bba0 i386 syscall audit fast-path
> 
> Cc: stable@vger.kernel.org
> Cc: Roland McGrath <roland@redhat.com>
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> I realize that the syscall audit fast path and badsys code, on 32-bit
> x86 no less, is possibly one of the least fun things in the kernel to
> review, but this is still a real security bug and should get fixed :(
> 
> So I'm cc-ing a bunch of people and maybe someone will review it.

Well, AFAICS, you're rerouting execution so that the audit stuff gets
properly "unwound" before returning to userspace. Which makes sense to
me.

Would it really work in all possible cases and isn't it causing any
other problems?

No friggin' idea - it would need extensive hammering to confirm it is ok
IMHO.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
