Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaBARLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:11:14 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:49890 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102AbaBARLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:11:13 -0500
MIME-Version: 1.0
In-Reply-To: <52ED1626.7060905@ladisch.de>
References: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net>
 <52ED1626.7060905@ladisch.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Feb 2014 09:10:51 -0800
Message-ID: <CALCETrVKfykqOP=+LPwCRh5H4SJvzsDb8pa2uZ=UBiOx22RdCg@mail.gmail.com>
Subject: Re: [PATCH] x86: Remove hpet vclock support
To: Clemens Ladisch <clemens@ladisch.de>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 7:43 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Andy Lutomirski wrote:
>> The HPET is so amazingly slow that this is barely a win.
>
> What happens on CPUs where the TSC cannot be used for the clock?

vclock_gettime, etc will fall back to using syscalls, just like they
would on systems using the PIT timer.

>
>> it scares me a tiny bit to map a piece of crappy hardware where every
>> userspace program can poke at it (even if said poking is read-only).
>> Let's just remove it.
>
> So this mapping is a backdoor to bypass the restrictions on /dev/hpet?  ;-)
>

Yes, except that it's read-only.

At some point, someone will probably want to run code in a sandbox
that can't tell time at all.  That will be messy, but this is a decent
first little step.

--Andy
