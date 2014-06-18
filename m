Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbaFRIrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:47:19 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:54850 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965156AbaFRIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:47:12 -0400
Message-ID: <1403081230.1984.62.camel@x220>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 10:47:10 +0200
In-Reply-To: <52F89350.9090404@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
		<1391971686-9517-25-git-send-email-richard@nod.at>
		<1391974709.25855.3.camel@x220>	<52F7DF51.8000507@nod.at>
		<1391976929.25855.22.camel@x220>	<52F7E34E.3010509@nod.at>
	 <CAMuHMdX-CFScoxBoE3SMHT4+12mbxBPEL53-HVd+6bkGd3XX_g@mail.gmail.com>
	 <52F89350.9090404@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2014 08:47:10.0694 (UTC) FILETIME=[E4B5A060:01CF8AD1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Koichi,

On Mon, 2014-02-10 at 09:52 +0100, Richard Weinberger wrote:
> Am 10.02.2014 09:49, schrieb Geert Uytterhoeven:
> > On Sun, Feb 9, 2014 at 9:21 PM, Richard Weinberger <richard@nod.at> wrote:
> >> I assumed that every kernel developer is aware of that fact that unreachable/dead code
> >> should be removed.
> > 
> > Yes, it should be removed.
> > 
> > But that's not what you did. You did the Kconfig-equivalent of removing a
> > "#if 0" in a C source file, which causes havoc.
> 
> Fair point. I'll remove that code in v2.
> Hopefully I can catch all breakage on my testbed as many archs/configs are involved.

After first reporting this issue, in 2011, I tried to remove all dead
code hiding behind config GDBSTUB. I still have the results of that
attempt stashed away:
    $ git stash show stash@{12}
     arch/mn10300/Kconfig.debug                      |  122 +-----
     arch/mn10300/boot/compressed/misc.c             |    9 -
     arch/mn10300/include/asm/exceptions.h           |    7 -
     arch/mn10300/include/asm/gdb-stub.h             |  182 ---------
     arch/mn10300/kernel/Makefile                    |    3 -
     arch/mn10300/kernel/entry.S                     |   21 --
     arch/mn10300/kernel/gdb-io-serial-low.S         |   91 -----
     arch/mn10300/kernel/gdb-io-serial.c             |  174 ---------
     arch/mn10300/kernel/gdb-io-ttysm-low.S          |   93 -----
     arch/mn10300/kernel/gdb-io-ttysm.c              |  303 ---------------
     arch/mn10300/kernel/gdb-low.S                   |  115 ------
     arch/mn10300/kernel/gdb-stub.c                  | 1923 ---------------------------------------------------------------------------------------------
     arch/mn10300/kernel/head.S                      |   10 -
     arch/mn10300/kernel/mn10300-serial.c            |    9 -
     arch/mn10300/kernel/mn10300-serial.h            |   14 -
     arch/mn10300/kernel/mn10300-watchdog.c          |   14 +-
     arch/mn10300/kernel/process.c                   |    1 -
     arch/mn10300/kernel/smp-low.S                   |    4 -
     arch/mn10300/kernel/smp.c                       |    7 -
     arch/mn10300/mm/fault.c                         |    9 -
     arch/mn10300/mm/misalignment.c                  |    1 -
     arch/mn10300/mm/tlb-mn10300.S                   |   13 -
     arch/mn10300/unit-asb2303/include/unit/serial.h |   83 ----
     arch/mn10300/unit-asb2305/include/unit/serial.h |   76 ----
     arch/mn10300/unit-asb2305/unit-init.c           |    2 -
     arch/mn10300/unit-asb2364/include/unit/serial.h |   64 ----
     26 files changed, 2 insertions(+), 3348 deletions(-)

By then I admitted defeat.

I might be willing to revisit this and draft a series of patches to
clean that up properly. But I think I never got any reaction on
Richard's patch or my report. And I do prefer to know beforehand what
your plans are for config GDBSTUB.


Paul Bolle

