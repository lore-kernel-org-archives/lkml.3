Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3JHQAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:00:20 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751797Ab3JHQAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:00:16 -0400
Message-ID: <52542C0A.4010208@nod.at>
Date: Tue, 08 Oct 2013 18:00:10 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        vgupta@synopsys.com, catalin.marinas@arm.com, will.deacon@arm.com,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, vapier@gentoo.org,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, rkuo@codeaurora.org,
        tony.luck@intel.com, fenghua.yu@intel.com, takata@linux-m32r.org,
        geert@linux-m68k.org, james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        lethal@linux-sh.org, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org
Subject: Re: [PATCH 28/29] tracehook_signal_handler: Remove sig, info, ka
 and regs
References: <1381232179-4385-1-git-send-email-richard@nod.at> <1381232179-4385-4-git-send-email-richard@nod.at> <20131008154520.GD13318@ZenIV.linux.org.uk>
In-Reply-To: <20131008154520.GD13318@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.10.2013 17:45, schrieb Al Viro:
> On Tue, Oct 08, 2013 at 01:36:18PM +0200, Richard Weinberger wrote:
>> These parameters are nowhere used, so we can remove them.
> 
> I'm not sure it's a good idea...  OTOH, it probably has no business in
> tracehook.h anymore - it's only called from signal_delivered(), so if
> we decide to insert some ptrace-related work, we can bloody well do it
> there these days.  It used to be called all over the place in arch/*,
> which made a centralized definition (and getting all potentially relevant
> data to it) a lot more important.  So I'd probably suggest killing that
> function off completely - signal_delivered() acts as such centralized
> location these days.

Okay. Will kill tracehook_signal_handler() and merge it's functionality
into signal_delivered().

Thanks,
//richard

