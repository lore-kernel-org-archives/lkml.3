Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbbAFF7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 00:59:50 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34192 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbbAFF7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 00:59:49 -0500
MIME-Version: 1.0
In-Reply-To: <20150106040428.GR2915@two.firstfloor.org>
References: <cover.1419900414.git.luto@amacapital.net> <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
 <54A64E6D.1020304@linux.intel.com> <87mw5x0xjz.fsf@tassilo.jf.intel.com>
 <54AAFFA3.6000901@linux.intel.com> <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
 <20150106040428.GR2915@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 21:59:27 -0800
Message-ID: <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 8:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> We should avoid arch_prctl because glibc won't add a syscall stub that
>> libgcc or whatever would want?  My mind boggles.
>
> Please turn brain on before posting.

Brain was on.

>
> Of course they would add it. But only in the next version. Which means
> everyone using older glibc would be out of luck. So all the users
> would be stuck using syscall(). Anything you may gain in the kernel
> would be totally made up by that.
>

ISTM libmpx shouldn't link against glibc at all -- what if libmpx
users want to use an alternate runtime (musl, Go, etc.)?

But I decided to check whether libmpx links against glibc, and I can't
find sources for it at all.  Do they exist?  Is there any code with
source available that invokes this prctl?

If not, I personally have very little sympathy for the argument that a
binary buried in the depths of the Intel SDE would need to change if
we switched to using arch_prctl.  And I think that it should issue the
syscall itself without using glibc, in which case the syscall wrapper
issue is moot.

--Andy

> BTW I added arch_prctl, but in hindsight it wasn't good idea.
>
> -Andi



-- 
Andy Lutomirski
AMA Capital Management, LLC
