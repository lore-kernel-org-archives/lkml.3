Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaA0Qpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:45:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39747 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbaA0Qpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:45:53 -0500
Date: Mon, 27 Jan 2014 17:45:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Michael Matz <matz@suse.de>,
        Michal Hocko <mhocko@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
Message-ID: <20140127164544.GE6839@pd.tnic>
References: <20140127163758.GC6839@pd.tnic>
 <52E68C25.1070804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E68C25.1070804@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 08:41:09AM -0800, H. Peter Anvin wrote:
> I don't think it'd hurt... although I think the above pretty much
> requires that the code contain actual floating-point types to ever be
> generated.

Yes, that is supposed to catch usage of the 'E' floating constant, for
example, in definitions. It is a build-time assertion, if you want. :)

> The issue with MMX/SSE is that an autovectorizing compiler could
> decide to use them for *integer* code.

Right, and we don't want the FPU state handling if it can be helped.

> -mno-fp-ret-in-387 in particular will only ever apply if a function
> return type is a floating-point type.

Yeah, this is for when using -msoft-float == -mno-80387 which still can
generate FPU insns according to the manpage:

           On machines where a function returns floating-point results in the 80387
           register stack, some floating-point opcodes may be emitted even if
           -msoft-float is used.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
