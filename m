Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaF3NiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:38:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42705 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaF3NiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:38:07 -0400
Date: Mon, 30 Jun 2014 15:38:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: /proc/cpuinfo confusion with AMD processors
Message-ID: <20140630133803.GE4766@pd.tnic>
References: <53B15D27.9010306@redhat.com>
 <20140630131309.GA5199@pd.tnic>
 <53B16621.50505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B16621.50505@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 09:29:05AM -0400, Prarit Bhargava wrote:
> Yes, I get that. But this doesn't uniquely identify *which* processor
> it is.

What do you mean, which processor it is? You want to know which
processor on the motherboard, physically? When you look at the mobo and
if all is enumerated regularly and you have a, say, two socket system
with the processors above, to be able to say that processor 31 is the
16th core on the second node on the motherboard? Something like that?

> Admins load systems relative to nodes, and look at /proc/cpuinfo as a
> "known" place to get that info. At the end of the day I'd like to be
> able to human-read /proc/cpuinfo and get the correct data out of it
> without jumping through hoops

What correct data? All that's there is correct AFAICT. Give an example
of what you want to do?

> to get processor location information. I can, in theory, use the
> initial apicid and the apicid to map everything out ... but I
> shouldn't have to. /proc/cpuinfo provides an easy look up for this
> data for Intel; why not for AMD?

What does it show on Intel that's clear there and that's puzzling you on
AMD?

> Additionally the turbostat utility, for example, is broken because of
> this lack of info. It assumes that /sys/../cpu/cpuX/topology/core_id
> is *per package* when on AMD systems it is reported as per node.

The turbostat utility might need some testing and fixing on AMD. If you
can get some resources to do that I think everyone will profit from it.

> I read that exact same thing somewhere else. The argument you're
> making is that it might be broken for some other reason. It already is
> completely misleading and utterly useless in the above case. A simple
> test patch to arch/x86/kernel/cpu/proc.c shows that including the
> information above is trivial. Adding it /sys/.../cpu/cpuX/topology is
> a little bit more difficult.

And I'm still saying that that information - albeit being trivial to
add - might be lying on some system doing renumbering. So, again: what
exactly do you want to be able to figure out from /proc/cpuinfo and what
is puzzling you? Give concrete examples please...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
