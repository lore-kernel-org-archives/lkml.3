Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbaCDUor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:44:47 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757156AbaCDUne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:43:34 -0500
Message-ID: <53163ADE.8080905@nod.at>
Date: Tue, 04 Mar 2014 21:43:10 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, vgupta@synopsys.com, catalin.marinas@arm.com,
        will.deacon@arm.com, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        vapier@gentoo.org, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
        rkuo@codeaurora.org, tony.luck@intel.com, fenghua.yu@intel.com,
        takata@linux-m32r.org, geert@linux-m68k.org, james.hogan@imgtec.com,
        monstr@monstr.eu, yasutake.koichi@jp.panasonic.com,
        ralf@linux-mips.org, jonas@southpole.se, jejb@parisc-linux.org,
        deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        liqin.linux@gmail.com, lennox.wu@gmail.com, cmetcalf@tilera.com,
        gxt@mprc.pku.edu.cn, linux-xtensa@linux-xtensa.org,
        akpm@linux-foundation.org, tj@kernel.org, hch@infradead.org
Subject: Re: [PATCH 28/44] Add translate_signal() helper
References: <1393804758-7916-1-git-send-email-richard@nod.at> <1393804758-7916-6-git-send-email-richard@nod.at> <20140304184109.GB19393@redhat.com>
In-Reply-To: <20140304184109.GB19393@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.03.2014 19:41, schrieb Oleg Nesterov:
> On 03/03, Richard Weinberger wrote:
>>
>> +static inline int translate_signal(int sig)
>> +{
>> +	struct thread_info *info = current_thread_info();
>> +
>> +	if (info->exec_domain
> 
> Afaics it can't be NULL.

Good point. Will change.

>> && info->exec_domain->signal_invmap && sig < 32)
>> +		return info->exec_domain->signal_invmap[sig];
>> +
> 
> And why default_exec_domain has .signal_invmap = ident_map ?
> translate_signal-like code should check ->signal_invmap != NULL
> anyway.
> 
> Off topic, but can't we kill exec_domain->signal_map ? it seems that
> it is unused.
> 
> Hmm. And who actually uses exec_domain->handler() ?? asm-offsets.c,
> but I do not see any usage of TI_EXEC_DOMAIN.
> 
> In short: I agree with this change but I am totally confused. To the
> point, I am not sure I even understand ->signal_invmap. I mean, it
> seems that only arthur_exec_domain has a non-ident map. Why, say,
> x86 does signr_convert() ? and only if CONFIG_X86_32? Is there any
> external module which does register_exec_domain(strange_invmap) ?

I remember a discussion with Al where he noted that register_exec_domain()
is currently only used by out of tree horrors. B-)

I'm sure we can rip it out of most archs. They seem to have it only because
they've copy&pasted it from i386.

Thanks,
//richard
